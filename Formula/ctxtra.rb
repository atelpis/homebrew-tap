class Ctxtra < Formula
  desc "Add your instruction files and skills to coding-agent sessions"
  homepage "https://github.com/ctxtra/ctxtra"
  url "https://github.com/ctxtra/ctxtra/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "eef3b86f287f94caad7ebef29be342d9f71d665f12601239acd25159f32203a0"
  license "MIT"
  head "https://github.com/ctxtra/ctxtra.git", branch: "main"

  bottle do
    root_url "https://github.com/atelpis/homebrew-tap/releases/download/ctxtra-0.6.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "60a80c13a099573ad77da0f6963380184c4950cee42f48c46c78e8f0ee1723d8"
    sha256 cellar: :any,                 x86_64_linux: "251bd5ddc4b0f40c642d2a559e036e1ada80cfd739b7e0b07b13dc81fb1e2ec8"
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
