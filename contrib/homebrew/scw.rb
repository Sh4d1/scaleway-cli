require "language/go"

class Scw < Formula
  desc "Manage BareMetal Servers from Command Line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.12.tar.gz"
  sha256 "a63f73d6781498bd438381f223eea47b47cb49bc0a93cf0b639042cecc48c91a"
  version "1.12"

  head "https://github.com/scaleway/scaleway-cli.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    ENV["GO15VENDOREXPERIMENT"] = "1"
    (buildpath/"src/github.com/scaleway/scaleway-cli").install Dir["*"]

    system "go", "build", "-o", "#{bin}/scw", "-v", "-ldflags", "-X  github.com/scaleway/scaleway-cli/pkg/scwversion.GITCOMMIT=homebrew", "github.com/scaleway/scaleway-cli/cmd/scw/"
 # we remove our .scw-cache.db file, to clean the cache of scw
 # this file is created and handled by scw
    rm_f "~/.scw-cache.db"

    bash_completion.install "src/github.com/scaleway/scaleway-cli/contrib/completion/bash/scw"
    zsh_completion.install "src/github.com/scaleway/scaleway-cli/contrib/completion/zsh/_scw"
  end

  def caveats
    "Use `scw login` to set up the correct environment to use scaleway-cli."
  end

  test do
    output = shell_output(bin/"scw version")
    assert_match "OS/Arch (client): darwin/amd64", output
  end
end
