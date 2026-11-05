class Ctxtra < Formula
  desc "Add your instruction files and skills to coding-agent sessions"
  homepage "https://github.com/atelpis/ctxtra"
  url "https://github.com/atelpis/ctxtra/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "a0116c68e1ce843ee1691e6de890438a17f41f3307c5f5f16006146abc4f69e2"
  license "MIT"
  head "https://github.com/atelpis/ctxtra.git", branch: "main"

  bottle do
    root_url "https://github.com/atelpis/homebrew-tap/releases/download/ctxtra-0.3.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "e39aca2aafb52279960863505e060fe77c5633cada550214b3ce21e978961627"
    sha256 cellar: :any,                 x86_64_linux: "b65ee46215e2af3530ebc794305c0490eedcc7052e6a2b071a3af6079a85b4d9"
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
