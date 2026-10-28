class Ctxtra < Formula
  desc "Add your instruction files and skills to coding-agent sessions"
  homepage "https://github.com/atelpis/ctxtra"
  url "https://github.com/atelpis/ctxtra/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "9f361db484992a2468051804d334578ec1bab61f2f76691e596f568d2dd58aba"
  license "MIT"
  head "https://github.com/atelpis/ctxtra.git", branch: "main"

  bottle do
    root_url "https://github.com/atelpis/homebrew-tap/releases/download/ctxtra-0.2.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "9d3a757080ffc96e358616567efb5c72956c50fc0bd97838f524d2175d394036"
    sha256 cellar: :any,                 x86_64_linux: "68d6d8297412b31596b2fe3116d02623da1aa7224fc381221a6db3903b67aacf"
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
