# github.com/brianmcgee has lots of great ideas for going above and beyond for this
{
	description = "Nix package for Xonsh";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		devshell.url = "github:numtide/devshell";
		flake-parts.url = "github:hercules-ci/flake-parts";
	};

	outputs = { devshell, flake-parts, self, ... }@inputs:
	flake-parts.lib.mkFlake { inherit inputs; } {
		imports = [
			inputs.devshell.flakeModule
		];
		flake = {
			# Universal things
			overlays.default = final: prev: {};
		};
		systems = [
			"x86_64-linux"
			"aarch64-linux"
			"x86_64-darwin"
			"aarch64-darwin"
		];
		perSystem = { config, pkgs, self', ... }@inputs': let
			lib = pkgs.lib;
		in {
			# https://numtide.github.io/devshell/intro.html
			devshells.default = {
				# These commands will be shown in the motd that users read
				# upon entering the shell
				commands = [{
					package = pkgs.python3;
					category = "languages";
					help = "Python 3 interpreter";
				}];
			};

			# This is not special, this is just flakes
			packages = {
				default = pkgs.python3.pkgs.callPackage (import ./xonsh.nix) { };
			};

			# https://community.flake.parts/process-compose-flake
			# The items within this are accessible under self'.packages.{name} that matches their names here
			# and will bring up a very nice GUI showing the status of each command within the processes
			#process-compose = {
			#	dev-server = {
			#		imports = [ inputs.services-flake-processComposeModules.default ];
			#		services.mysql.default = {
			#			enable = true;
			#			dataDir = "./.maria/data";
			#			settings.mysqld.port = 3336;
			#			initialDatabases = [{ name = "development"; }];
			#			ensureUsers = [ {
			#				password = "devpassword";
			#				name = "devuser";
			#				ensurePermissions."*.*" = "ALL PRIVILEGES";
			#			} ];
			#		};
			#		settings = {
			#			environment = {};
			#			processes = {
			#				start = {
			#					depends_on.default-configuration.condition = "process_completed_successfully";
			#					command = "echo Wrte the start command here";
			#				};
			#			};
			#		};
			#	};
			#	prod-server.settings.processes = {
			#		import.command = "${lib.getExe pkgs.podman} load -i ${self'.packages.default}";
			#		run = {
			#			command = "${lib.getExe pkgs.podman} run --rm -p 8000:80 gregs-homepage:latest";
			#			depends_on.import.condition = "process_completed_successfully";
			#			readiness_probe.http_get = {
			#				host = "localhost";
			#				port = 8000;
			#			};
			#		};
			#	};
			#};
		};
	};
}
