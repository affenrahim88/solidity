/*
	This file is part of solidity.

	solidity is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	solidity is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with solidity.  If not, see <http://www.gnu.org/licenses/>.
*/
// SPDX-License-Identifier: GPL-3.0

#include <test/tools/ossfuzz/SolidityGenerator.h>

#include <libsolutil/Whiskers.h>

using namespace solidity::test::fuzzer;
using namespace solidity::util;
using namespace std;
using PrngUtil = solidity::test::fuzzer::GenerationProbability;

GeneratorBase::GeneratorBase(std::shared_ptr<SolidityGenerator> _mutator)
{
	mutator = std::move(_mutator);
	rand = mutator->randomEngine();
	state = mutator->testState();
}

string GeneratorBase::visitChildren()
{
	ostringstream os;
	// Randomise visit order
	vector<GeneratorPtr> randomisedChildren;
	for (auto child: generators)
		randomisedChildren.push_back(child);
	shuffle(randomisedChildren.begin(), randomisedChildren.end(), *rand);
	for (auto child: randomisedChildren)
		os << std::visit(GeneratorVisitor{}, child);
	return os.str();
}

string TestState::randomPath(set<string> const& _sourceUnitPaths) const
{
	auto it = _sourceUnitPaths.begin();
	/// Advance iterator by n where 0 <= n <= sourceUnitPaths.size() - 1
	size_t increment = PrngUtil{}.distributionOneToN(_sourceUnitPaths.size(), rand) - 1;
	solAssert(
		increment >= 0 && increment < _sourceUnitPaths.size(),
		"Solc custom mutator: Invalid increment"
	);
	advance(it, increment);
	return *it;
}

string TestState::randomPath() const
{
	solAssert(!empty(), "Solc custom mutator: Null test state");
	return randomPath(sourceUnitPaths);
}

void TestState::print(std::ostream& _os) const
{
	_os << "Printing test state" << std::endl;
	for (auto const& item: sourceUnitPaths)
		_os << "Source path: " << item << std::endl;
}

string TestState::randomNonCurrentPath() const
{
	/// To obtain a source path that is not the currently visited
	/// source unit itself, we require at least one other source
	/// unit to be previously visited.
	solAssert(size() >= 2, "Solc custom mutator: Invalid test state");

	set<string> filteredSourcePaths;
	string currentPath = currentSourceUnitPath;
	copy_if(
		sourceUnitPaths.begin(),
		sourceUnitPaths.end(),
		inserter(filteredSourcePaths, filteredSourcePaths.begin()),
		[currentPath](string const& _item) {
			return _item != currentPath;
		}
	);
	return randomPath(filteredSourcePaths);
}

void TestCaseGenerator::setup()
{
	addGenerators({
		mutator->generator<SourceUnitGenerator>()
	});
}

string TestCaseGenerator::visit()
{
	ostringstream os;
	for (unsigned i = 0; i < PrngUtil{}.distributionOneToN(s_maxSourceUnits, rand); i++)
	{
		string sourcePath = path();
		os << "\n"
			<< "==== Source: "
			<< sourcePath
			<< " ===="
	        << "\n";
		updateSourcePath(sourcePath);
		m_numSourceUnits++;
		os << visitChildren();
	}
	return os.str();
}

void SourceUnitGenerator::setup()
{
	addGenerators({
		mutator->generator<ImportGenerator>(),
		mutator->generator<PragmaGenerator>()
	});
}

string SourceUnitGenerator::visit()
{
	return visitChildren();
}

string PragmaGenerator::visit()
{
	static constexpr const char* preamble = R"(
		pragma solidity >= 0.0.0;
		pragma experimental SMTChecker;
	)";
	// Choose equally at random from coder v1 and v2
	string abiPragma = "pragma abicoder v" +
		to_string(PrngUtil{}.distributionOneToN(2, rand)) +
		";\n";
	return preamble + abiPragma;
}

string ImportGenerator::visit()
{
	/*
	 * Case 1: No source units defined
	 * Case 2: One source unit defined
	 * Case 3: At least two source units defined
	 */
	ostringstream os;
	// Self import with a small probability only if
	// there is one source unit present in test.
	if (state->size() == 1)
	{
		if (PrngUtil{}.probable(s_selfImportInvProb, rand))
			os << "import "
			   << "\""
			   << state->randomPath()
			   << "\";";
	}
	else
	{
		// Import a different source unit if at least
		// two source units available.
		os << "import "
			<< "\""
			<< state->randomNonCurrentPath()
			<< "\";";
	}
	return os.str();
}

template <typename T>
shared_ptr<T> SolidityGenerator::generator()
{
	for (auto& g: m_generators)
		if (holds_alternative<shared_ptr<T>>(g))
			return get<shared_ptr<T>>(g);
	solAssert(false, "");
}

SolidityGenerator::SolidityGenerator(unsigned _seed)
{
	m_rand = make_shared<RandomEngine>(_seed);
	m_generators = {};
	m_state = make_shared<TestState>(m_rand);
}

template <size_t I>
void SolidityGenerator::createGenerators()
{
	if constexpr (I < std::variant_size_v<Generator>)
	{
		createGenerator<std::variant_alternative_t<I, Generator>>();
		createGenerators<I + 1>();
	}
}

string SolidityGenerator::generateTestProgram()
{
	createGenerators();
	for (auto& g: m_generators)
		std::visit(AddDependenciesVisitor{}, g);
	string program = generator<TestCaseGenerator>()->generate();
	destroyGenerators();
	return program;
}
