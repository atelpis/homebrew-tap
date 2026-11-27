class CtxtraRc < Formula
  desc "Add instruction files and skills to coding-agent sessions (release candidates)"
  homepage "https://github.com/ctxtra/ctxtra"
  url "https://github.com/ctxtra/ctxtra/archive/refs/tags/v0.7.0-rc.1.tar.gz"
  sha256 "6eb8e8a3a96d410fa937436ef198e876cc56a2f4d6e7a8ff17b1ffbdd2b9a4b8"
  license "MIT"
  head "https://github.com/ctxtra/ctxtra.git", branch: "main"

  bottle do
    root_url "https://github.com/atelpis/homebrew-tap/releases/download/ctxtra-rc-0.7.0-rc.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "7ad82be697383e8b1185ce323d34deb2cf230ba63084ee557e767b8787295aa4"
    sha256 cellar: :any,                 x86_64_linux: "034bfcd8e5b33870b1eff334a203fd771becc93608b45b0ddbd657e5c6f7dcfb"
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
    system bin/"ctxtra", "binding", "add", "t", "--instruction", testpath/"note.md"
    assert_match "brew test note", shell_output("#{bin}/ctxtra context show #{testpath}")
  end
end
