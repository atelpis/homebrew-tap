class CtxtraRc < Formula
  desc "Add instruction files and skills to coding-agent sessions (release candidates)"
  homepage "https://github.com/ctxtra/ctxtra"
  url "https://github.com/ctxtra/ctxtra/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "865a1bc209971aeeb95609d089fd990c8473909d8f8f3d20d36ca8b297aa5093"
  license "MIT"
  head "https://github.com/ctxtra/ctxtra.git", branch: "main"

  bottle do
    root_url "https://github.com/atelpis/homebrew-tap/releases/download/ctxtra-rc-0.5.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "9e636457f281dc61927cb80d4fede3e7feda2c639d1d9bb02f9ce9b5b93120c2"
    sha256 cellar: :any,                 x86_64_linux: "8c6da4b0961e07bd569896ecd0f692c6b08f7c074aaa5f13dfb99b175d1abbc3"
  end

  depends_on "go" => :build

  conflicts_with "ctxtra", because: "both install the `ctxtra` binary"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}", output: bin/"ctxtra"),
           "./cmd/ctxtra"
  end

  def caveats
    <<~EOS
      ctxtra-rc gets every release candidate and every release of ctxtra.
      To add ctxtra's hooks to your agents:
        ctxtra onboard
      To go back to releases only:
        brew uninstall ctxtra-rc && brew install atelpis/tap/ctxtra
      Before you uninstall ctxtra for good, remove the hooks:
        ctxtra setup --remove
    EOS
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/ctxtra version").strip
    (testpath/"note.md").write "brew test note"
    system bin/"ctxtra", "binding", "add", "t", "--global", "--instruction", testpath/"note.md"
    assert_match "brew test note", shell_output("#{bin}/ctxtra context show #{testpath}")
  end
end
