# want HTTP support
{pkgs}:
with pkgs;
  stdenv.mkDerivation rec {
    pname = "fio";
    version = "3.35";

    src = fetchFromGitHub {
      owner = "axboe";
      repo = "fio";
      rev = "fio-${version}";
      sha256 = "sha256-8LMpgayxBebHb0MXYmjlqqtndSiL42/yEQpgamxt9kI=";
    };

    enableParallelBuilding = true;
    buildInputs =
      [curl openssl zlib]
      ++ lib.optional (!stdenv.isDarwin) libaio;
  }
