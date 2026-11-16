class Ctxtra < Formula
  desc "Add your instruction files and skills to coding-agent sessions"
  homepage "https://github.com/ctxtra/ctxtra"
  url "https://github.com/ctxtra/ctxtra/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "865a1bc209971aeeb95609d089fd990c8473909d8f8f3d20d36ca8b297aa5093"
  license "MIT"
  head "https://github.com/ctxtra/ctxtra.git", branch: "main"

  bottle do
    root_url "https://github.com/atelpis/homebrew-tap/releases/download/ctxtra-0.5.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "180ca1774b5a66035777ae27f5e7f17f7cd522dcd52ba15056fad3b8b6c710a2"
    sha256 cellar: :any,                 x86_64_linux: "d105e4005ab0ab28c611f4043efffbeacca9541a4504e2de5e68da04cb27df52"
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
