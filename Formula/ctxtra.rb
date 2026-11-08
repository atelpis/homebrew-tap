class Ctxtra < Formula
  desc "Add your instruction files and skills to coding-agent sessions"
  homepage "https://github.com/ctxtra/ctxtra"
  url "https://github.com/ctxtra/ctxtra/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "eff3f0716bac87a36425cc2d4e1270d9c0a9c57f3726ae71e6a71f1356d3486c"
  license "MIT"
  head "https://github.com/ctxtra/ctxtra.git", branch: "main"

  bottle do
    root_url "https://github.com/atelpis/homebrew-tap/releases/download/ctxtra-0.4.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "d0e8267e5ef689aa9d3b5e53d08de18048222efe49dfbcc595b19ccac8352b7f"
    sha256 cellar: :any,                 x86_64_linux: "3ccfea8a7c71f846fa4c38c1c5d836468c0d71696dbfae8c1993661fb9e55068"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/ctxtra"
  end

  def caveats
    <<~EOS
      To add ctxtra's hooks to your agents:
        ctxtra onboard
      Before you uninstall ctxtra, remove them:
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
