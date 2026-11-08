class Ctxtra < Formula
  desc "Add your instruction files and skills to coding-agent sessions"
  homepage "https://github.com/atelpis/ctxtra"
  url "https://github.com/atelpis/ctxtra/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "fd7184d653dbebc205fcde84c0038af13dd2c16da164e117e7e42eade487851f"
  license "MIT"
  head "https://github.com/atelpis/ctxtra.git", branch: "main"

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
