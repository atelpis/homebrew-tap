class CtxtraRc < Formula
  desc "Add instruction files and skills to coding-agent sessions (release candidates)"
  homepage "https://github.com/ctxtra/ctxtra"
  url "https://github.com/ctxtra/ctxtra/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "81acff7adb1bd1dc57391fa8917315e4852392134ceb082ff3f123683c2909a1"
  license "MIT"
  head "https://github.com/ctxtra/ctxtra.git", branch: "main"

  bottle do
    root_url "https://github.com/atelpis/homebrew-tap/releases/download/ctxtra-rc-0.5.0-rc.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "73d6b7379a6d934797c43893c533389f0a7cd275b93e9f9cd589cfa1a68d4cd0"
    sha256 cellar: :any,                 x86_64_linux: "d848693a56689bff169887a36d06055594fc8b91888faafde1b78cef4da2908a"
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
