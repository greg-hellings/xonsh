{
	lib,
	buildPythonApplication,
	setuptools,

	ply,
	prompt-toolkit,
	pygments,

	# check inputs
	git,
	glibcLocales,
	pip,
	pyte,
	pytest-mock,
	pytest-subprocess,
	pytestCheckHook,
	requests,
}:

buildPythonApplication rec {
	pname = "xonsh";
	version = "git-head";

	src = ./.;

	# Gets pulled into running environments as well
	dependencies = [
		ply
		prompt-toolkit
		pygments
	];

	nativeCheckInputs = [
		git
		glibcLocales
		pip
		pyte
		pytest-mock
		pytest-subprocess
		pytestCheckHook
		requests
	];

	meta = with lib; {
		description = "Modern, full-featured and cross-platform shell";
		homepage = "https://xon.sh/";
		license = licenses.bsd3;
		maintainers = [];
	};
}
