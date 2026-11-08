class Ctxtra < Formula
  desc "Add your instruction files and skills to coding-agent sessions"
  homepage "https://github.com/ctxtra/ctxtra"
  url "https://github.com/ctxtra/ctxtra/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "eff3f0716bac87a36425cc2d4e1270d9c0a9c57f3726ae71e6a71f1356d3486c"
  license "MIT"
  head "https://github.com/ctxtra/ctxtra.git", branch: "main"

  bottle do
    root_url "https://github.com/atelpis/homebrew-tap/releases/download/ctxtra-0.4.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "d7031e90660acac63987f505367429839fb54db0a21c98bc610121968574c628"
    sha256 cellar: :any,                 x86_64_linux: "21f90ba3cd7b5e2713f2410d441f6d2696a4dfb5258eb5d9b28e9dc242455dc6"
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
