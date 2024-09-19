/**
	* toSshConfig :: lib -> AttrSet -> string
	* Converts an attribute set into an SSH config file (i.e. ~/.ssh/config).
	* 
	* ## Example
	* ```nix
	* toSshConfig {
  * 	host.dev = {
  * 		HostName = "dev.example.com";
	* 		User = "valerie";
	* 		Port = 2077;
	* 	};
	*   host."*" = {
	* 		IdentityFile "~/.ssh/secret.key";
	* 	};
	* }
	* # Host dev
	* # 	HostName dev.example.com
	* # 	User valerie
	* # 	Port 2077
	* # Host *
	* # 	IdentityFile ~/.ssh/secret.key
	* ```
	*/
lib: sshConfig:

let
	# toString :: Any -> String
	toString = v:
		if builtins.typeOf v == "bool" then (if v then "true" else "false")
		else builtins.toString v;

	# convertField :: String -> Any -> String
	convertField = option: value: "\t${option} ${toString value}";
	# foldFields :: List<String> -> String -> String -> List<String>
	foldFields = acc: option: value: acc ++ [(convertField option value)];
	# convertFields :: AttrSet -> String
	convertFields = stanza:
		let fields = lib.attrsets.foldlAttrs foldFields [] stanza; in
		lib.strings.concatStringsSep "\n" fields;
	
	# convertStanza :: String -> AttrSet -> String
	convertStanza = hostPattern: fields:
		"Host ${hostPattern}\n${convertFields fields}";
	# foldStanzas :: List<String> -> String -> AttrSet -> List<String>
	foldStanzas = acc: hostPattern: fields: acc ++ [(convertStanza hostPattern fields)];
	# convertStanzas :: AttrSet -> String
	convertStanzas = config:
		let stanzas = lib.attrsets.foldlAttrs foldStanzas [] config; in
		lib.strings.concatStringsSep "\n\n" stanzas;
in

convertStanzas sshConfig.host

