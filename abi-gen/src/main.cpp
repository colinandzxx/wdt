#include "abi_gen.h"
#include  <nlohmann/json.hpp>
#include<iostream>


using namespace clang;
using namespace clang::tooling;
using namespace bchainio;
using namespace std;
using json = nlohmann::json;

namespace bchainio {
void to_json(json& j, const action_def& p) {
	j = json{{"name", p.name}, {"type", p.type}};
}

void from_json(const json& j, action_def& p) {
	j.at("name").get_to(p.name);
	j.at("type").get_to(p.type);
}

void to_json(json& j, const type_def& p) {
	j = json{{"new_type_name", p.new_type_name}, {"type", p.type}};
}

void from_json(const json& j, type_def& p) {
	j.at("new_type_name").get_to(p.new_type_name);
	j.at("type").get_to(p.type);
}

void to_json(json& j, const field_def& p) {
	j = json{{"name", p.name}, {"type", p.type}};
}

void from_json(const json& j, field_def& p) {
	j.at("name").get_to(p.name);
	j.at("type").get_to(p.type);
}

void to_json(json& j, const struct_def& p) {
	j = json{{"name", p.name}, {"base", p.base}, {"fields", p.fields}};
}

void from_json(const json& j, struct_def& p) {
	j.at("name").get_to(p.name);
	j.at("base").get_to(p.base);
	j.at("fields").get_to(p.fields);
}






void to_json(json& j, const abi_def& p) {
	j = json{{"version", p.version}, {"types", p.types}, {"structs", p.structs}, {"actions", p.actions}};
}

void from_json(const json& j, abi_def& p) {
    j.at("version").get_to(p.version);
    j.at("types").get_to(p.types);
    j.at("structs").get_to(p.structs);
    j.at("actions").get_to(p.actions);
}

}


std::unique_ptr<FrontendActionFactory> create_factory(bool verbose, bool opt_sfs, string abi_context, abi_def& output, const string& contract, const vector<string>& actions) {

  struct abi_frontend_action_factory : public FrontendActionFactory {

    bool                   verbose;
    bool                   opt_sfs;
    string                 abi_context;
    abi_def&        	   output;
    const string&          contract;
    const vector<string>&  actions;

    abi_frontend_action_factory(bool verbose, bool opt_sfs, string abi_context,
      abi_def& output, const string& contract, const vector<string>& actions) : verbose(verbose),
      abi_context(abi_context), output(output), contract(contract), actions(actions) {}

    clang::FrontendAction *create() override {
      return new generate_abi_action(verbose, opt_sfs, abi_context, output, contract, actions);
    }

  };

  return std::unique_ptr<FrontendActionFactory>(
      new abi_frontend_action_factory(verbose, opt_sfs, abi_context, output, contract, actions)
  );
}

std::unique_ptr<FrontendActionFactory> create_find_macro_factory(string& contract, vector<string>& actions, string abi_context) {

  struct abi_frontend_macro_action_factory : public FrontendActionFactory {

    string&          contract;
    vector<string>&  actions;
    string           abi_context;

    abi_frontend_macro_action_factory (string& contract, vector<string>& actions,
      string abi_context ) : contract(contract), actions(actions), abi_context(abi_context) {}

    clang::FrontendAction *create() override {
      return new find_eosio_abi_macro_action(contract, actions, abi_context);
    }

  };

  return std::unique_ptr<FrontendActionFactory>(
    new abi_frontend_macro_action_factory(contract, actions, abi_context)
  );
}

static cl::OptionCategory abi_generator_category("ABI generator options");

static cl::opt<std::string> abi_context(
    "context",
    cl::desc("ABI context"),
    cl::cat(abi_generator_category));

static cl::opt<std::string> abi_destination(
    "destination-file",
    cl::desc("destination json file"),
    cl::cat(abi_generator_category));

static cl::opt<bool> abi_verbose(
    "verbose",
    cl::desc("show debug info"),
    cl::cat(abi_generator_category));

static cl::opt<bool> abi_opt_sfs(
    "optimize-sfs",
    cl::desc("Optimize single field struct"),
    cl::cat(abi_generator_category));

int main(int argc, const char **argv)
{ 
	abi_def output; 

	CommonOptionsParser op(argc, argv, abi_generator_category);
	ClangTool Tool(op.getCompilations(), op.getSourcePathList());

	string contract;
	vector<string> actions;
	int result = Tool.run(create_find_macro_factory(contract, actions, abi_context).get());
	if(!result) 
	{
		
		for(int i=0 ;i<actions.size();i++){
	
			cout<<actions[i]<<" ";
		}
		cout<<endl;
		
		result = Tool.run(create_factory(abi_verbose, abi_opt_sfs, abi_context, output, contract, actions).get());
		if(!result) {
			/*
			json j;
			j["xx"] = 99;
			
			j["list"] = { 1, 0, 2 };
			j["yy"] = "yyy";
			
			cout << j.dump(4) << endl;
			*/
			printf("output abi json format:\n");

			json jj = output;
			
			std::cout << jj.dump(4) << std::endl;

			printf("abi generation completed\n");
		}
	}
	return result;
} 

