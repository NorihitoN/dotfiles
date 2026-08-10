if [[ "$(uname)" == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# >>> JVM installed by coursier >>>
if [[ "$(uname)" == "Darwin" ]]; then
  export JAVA_HOME="$HOME/Library/Caches/Coursier/arc/https/github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.14%252B7/OpenJDK17U-jdk_aarch64_mac_hotspot_17.0.14_7.tar.gz/jdk-17.0.14+7/Contents/Home"
  export PATH="$PATH:$HOME/Library/Application Support/Coursier/bin"
else
  export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-$(dpkg --print-architecture 2>/dev/null || echo amd64)"
  export PATH="$PATH:$HOME/.local/share/coursier/bin"
fi
# <<< JVM installed by coursier <<<
