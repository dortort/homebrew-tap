# typed: false
# frozen_string_literal: true

class Dgossgen < Formula
  desc "Generate dgoss-ready test suites from Dockerfiles"
  homepage "https://github.com/dortort/dgossgen"
  version "0.2.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/dortort/dgossgen/releases/download/v0.2.0/dgossgen-aarch64-apple-darwin.tar.gz"
      sha256 "46d79fc3ab8a71963ee28c57e55dbb964ace841125a077004bf1bbbad3c5e206"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dortort/dgossgen/releases/download/v0.2.0/dgossgen-x86_64-apple-darwin.tar.gz"
      sha256 "d21d1d305310e49fcdf005c69dba21742676d8d7493bc67eebf8b86a02e9745b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/dortort/dgossgen/releases/download/v0.2.0/dgossgen-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b9ad3fb84e1b8b6b836b1c28e0dd3860ed2cb7719c77865167ff83e93e0c7412"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dortort/dgossgen/releases/download/v0.2.0/dgossgen-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ca91efc182791dea59fef8786c57ebc1427927d6a37acd36cf1477007d31ded9"
    end
  end

  def install
    bin.install "dgossgen"
  end

  test do
    system "#{bin}/dgossgen", "--version"
  end
end
