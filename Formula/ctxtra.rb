class Ctxtra < Formula
  desc "Add your instruction files and skills to coding-agent sessions"
  homepage "https://github.com/atelpis/ctxtra"
  url "https://github.com/atelpis/ctxtra/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "9a8f31146bdc40e0c9c08b8064549b28b6340cff7c95a62a80301bc3472cf0d2"
  license "MIT"
  head "https://github.com/atelpis/ctxtra.git", branch: "main"

  bottle do
    root_url "https://github.com/atelpis/homebrew-tap/releases/download/ctxtra-0.1.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "b5dbaead030309069dca7eadb03b458e6b8653a4f3c0792130b408fd37e3ff4b"
    sha256 cellar: :any,                 x86_64_linux: "ee5fe3dfeddfb01d61dc3031115d836cd3a88250ce4ab2601260d6cbbea7f1bd"
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
