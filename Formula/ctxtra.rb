class Ctxtra < Formula
  desc "Add your instruction files and skills to coding-agent sessions"
  homepage "https://github.com/atelpis/ctxtra"
  url "https://github.com/atelpis/ctxtra/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "13dfc5efb3cd17da9b9650b2eb894e095de982e65a8954f9556f4fa01bb11b37"
  license "MIT"
  head "https://github.com/atelpis/ctxtra.git", branch: "main"

  bottle do
    root_url "https://github.com/atelpis/homebrew-tap/releases/download/ctxtra-0.2.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "e4e28317d4c49ad31daba7ae63d775d570bf9c1ef85a950b58c1165f98ed05b7"
    sha256 cellar: :any,                 x86_64_linux: "bf8d56ef82997763acf1a9fd93bf32ca310f0c0bf4ddad9706ca0b002ee089c0"
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
