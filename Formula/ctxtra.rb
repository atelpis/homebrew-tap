class Ctxtra < Formula
  desc "Add your instruction files and skills to coding-agent sessions"
  homepage "https://github.com/ctxtra/ctxtra"
  url "https://github.com/ctxtra/ctxtra/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "81acff7adb1bd1dc57391fa8917315e4852392134ceb082ff3f123683c2909a1"
  license "MIT"
  head "https://github.com/ctxtra/ctxtra.git", branch: "main"

  bottle do
    root_url "https://github.com/atelpis/homebrew-tap/releases/download/ctxtra-0.5.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "f7c451530de37a73bbb507b6748558bb8244893aed6fcf210a8015c9e7dabed1"
    sha256 cellar: :any,                 x86_64_linux: "9e58bf959639911850f9b02dba3899be784e4f645927f67c093747732437de6b"
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
