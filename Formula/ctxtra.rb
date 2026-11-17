class Ctxtra < Formula
  desc "Add your instruction files and skills to coding-agent sessions"
  homepage "https://github.com/ctxtra/ctxtra"
  url "https://github.com/ctxtra/ctxtra/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "ff382dbeb1e6412f5e4db9d14e936413c4ca7510733a8465c6c45bcbd09fb460"
  license "MIT"
  head "https://github.com/ctxtra/ctxtra.git", branch: "main"

  bottle do
    root_url "https://github.com/atelpis/homebrew-tap/releases/download/ctxtra-0.5.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "36ebc62b8799d4d278171b5f1bd74b639f36290b66f1327bee092ded103ed684"
    sha256 cellar: :any,                 x86_64_linux: "b9c6959b9063164b3fe911423f7e2de6859649a4ccd6f831a7f49d51e4fb5610"
  end

  depends_on "go" => :build

  conflicts_with "ctxtra-rc", because: "both install the `ctxtra` binary"

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
