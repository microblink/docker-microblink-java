FROM alpine:3.13

LABEL maintainer="Matija Stepanic <matija.stepanic@microblink.com>" version="1.2"

# 1. where to store original OpenJDK
ENV JAVA_HOME_JDK /opt/openjdk-17
# 2. where to store generated custom Java runtime from original OpenJDK
ENV JAVA_HOME_JRE /opt/openjre-17

# Expose original OpenJDK and and custom Java runtime to the shell
ENV PATH $JAVA_HOME_JDK/bin:$JAVA_HOME_JRE/bin:$PATH

# Ref: https://github.com/docker-library/openjdk/blob/master/14/jdk/alpine/Dockerfile
# https://jdk.java.net/
ENV JAVA_VERSION 17-ea+14
ENV JAVA_URL https://download.java.net/java/early_access/alpine/14/binaries/openjdk-${JAVA_VERSION}_linux-x64-musl_bin.tar.gz
ENV JAVA_SHA256 f07a1ac921333dafac1cd886ad49600ce143be7efebd32e1a02599a8a0829dd4
# "For Alpine Linux, builds are produced on a reduced schedule and may not be in sync with the other platforms."

RUN set -eux; \
	\
	wget -O /openjdk.tgz "$JAVA_URL"; \
	echo "$JAVA_SHA256 */openjdk.tgz" | sha256sum -c -; \
	mkdir -p "$JAVA_HOME_JDK"; \
	tar --extract --file /openjdk.tgz --directory "$JAVA_HOME_JDK" --strip-components 1; \
	rm /openjdk.tgz; \
	\
# https://github.com/docker-library/openjdk/issues/212#issuecomment-420979840
# https://openjdk.java.net/jeps/341
	java -Xshare:dump; \
	\
# OpenJDK basic smoke test
	which java; \
	java --version; \
	javac --version; \
	jlink --version; \
	\
# All available OpenJDK modules are available as the output of the `java --list-modules`
# https://stackoverflow.com/a/56807371
# Please follow this tutorial to get only required modules for your specific application, or leave unchanged to have runtime with all available modules
# https://medium.com/azulsystems/using-jlink-to-build-java-runtimes-for-non-modular-applications-9568c5e70ef4
	export JAVA_MODULES=java.base,java.compiler,java.datatransfer,java.desktop,java.instrument,java.logging,java.management,java.management.rmi,java.naming,java.net.http,java.prefs,java.rmi,java.scripting,java.se,java.security.jgss,java.security.sasl,java.smartcardio,java.sql,java.sql.rowset,java.transaction.xa,java.xml,java.xml.crypto,jdk.accessibility,jdk.attach,jdk.charsets,jdk.compiler,jdk.crypto.cryptoki,jdk.crypto.ec,jdk.dynalink,jdk.editpad,jdk.hotspot.agent,jdk.httpserver,jdk.internal.ed,jdk.internal.jvmstat,jdk.internal.le,jdk.internal.opt,jdk.internal.vm.ci,jdk.jartool,jdk.javadoc,jdk.jcmd,jdk.jconsole,jdk.jdeps,jdk.jdi,jdk.jdwp.agent,jdk.jfr,jdk.jlink,jdk.jshell,jdk.jsobject,jdk.jstatd,jdk.localedata,jdk.management,jdk.management.agent,jdk.management.jfr,jdk.naming.dns,jdk.naming.rmi,jdk.net,jdk.sctp,jdk.security.auth,jdk.security.jgss,jdk.unsupported,jdk.unsupported.desktop,jdk.xml.dom,jdk.zipfs; \
# Generate custom java runtime
	jlink --no-header-files --no-man-pages --compress=2 --add-modules $JAVA_MODULES --output "$JAVA_HOME_JRE"; \
# Remove original JDK
	rm -rf "$JAVA_HOME_JDK"; \
	\
# https://github.com/docker-library/openjdk/issues/212#issuecomment-420979840
# https://openjdk.java.net/jeps/341
	java -Xshare:dump; \
	\
# basic smoke test
	which java; \
	java --version; \
	javac --version; \
	jlink --version

# https://docs.oracle.com/javase/10/tools/jshell.htm
# https://docs.oracle.com/javase/10/jshell/
# https://en.wikipedia.org/wiki/JShell
CMD ["jshell"]
