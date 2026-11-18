class CtxtraRc < Formula
  desc "Add instruction files and skills to coding-agent sessions (release candidates)"
  homepage "https://github.com/ctxtra/ctxtra"
  url "https://github.com/ctxtra/ctxtra/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "eef3b86f287f94caad7ebef29be342d9f71d665f12601239acd25159f32203a0"
  license "MIT"
  head "https://github.com/ctxtra/ctxtra.git", branch: "main"

  bottle do
    root_url "https://github.com/atelpis/homebrew-tap/releases/download/ctxtra-rc-0.6.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "1c3c6880a4939cc8a168cd6ec488ae101969252dacd26bf233f6a82f63ab642b"
    sha256 cellar: :any,                 x86_64_linux: "756ad9ec6dd25b311b41f9275be3c828756495287e0b268b89aff7f8fd8dc63c"
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
