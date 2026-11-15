class CtxtraRc < Formula
  desc "Add instruction files and skills to coding-agent sessions (release candidates)"
  homepage "https://github.com/ctxtra/ctxtra"
  url "https://github.com/ctxtra/ctxtra/archive/refs/tags/v0.5.0-rc.1.tar.gz"
  sha256 "4756dad759136e5bab557be1fc592ad595d7e9e47bd9c702e7f2164b02050b3e"
  license "MIT"
  head "https://github.com/ctxtra/ctxtra.git", branch: "main"

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
