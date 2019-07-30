/**
 *  @file
 *  @copyright defined in eos/LICENSE.txt
 */
#pragma once
#include <string>
#include <vector>
#include <nlohmann/json.hpp>
using json = nlohmann::json;


namespace bchainio {

typedef  std::string type_name;
typedef  std::string field_name;
typedef  std::string action_name;




struct type_def {
   type_def() = default;
   type_def(const type_name& new_type_name, const type_name& type)
   :new_type_name(new_type_name), type(type)
   {}

   type_name   new_type_name;
   type_name   type;
};

struct field_def {
   field_def() = default;
   field_def(const field_name& name, const type_name& type)
   :name(name), type(type)
   {}

   field_name name;
   type_name  type;


};

struct struct_def {
   struct_def() = default;
   struct_def(const type_name& name, const type_name& base, const std::vector<field_def>& fields)
   :name(name), base(base), fields(fields)
   {}

   type_name            name;
   type_name            base;
   std::vector<field_def>    fields;


};


struct action_def {
   action_def() = default;
   action_def(const action_name& name, const type_name& type)
   :name(name), type(type)
   {}

   action_name name;
   type_name   type;

};




struct error_message {
   error_message() = default;
   error_message( unsigned long long       error_code, const std::string& error_msg )
   : error_code(error_code), error_msg(error_msg)
   {}

   unsigned long long error_code;
   std::string   error_msg;
};

struct abi_def {
   abi_def() = default;
   abi_def(const std::vector<type_def>& types, const std::vector<struct_def>& structs, const std::vector<action_def>& actions, const std::vector<error_message>& error_msgs)
   :version("bchain::abi/1.0")
   ,types(types)
   ,structs(structs)
   ,actions(actions)
   ,error_messages(error_msgs)
   {}

   std::string                version = "bchainio::abi/1.0";
   std::vector<type_def>      types;
   std::vector<struct_def>    structs;
   std::vector<action_def>    actions;
   std::vector<error_message> error_messages;
};




} /// namespace eosio::chain
