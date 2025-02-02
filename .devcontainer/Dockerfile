#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Copyright (c) Elysia. 2024
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

    FROM debian:trixie

    COPY first-run-notice.txt /tmp/scripts/

    COPY change_source.sh /tmp/scripts/
    
    ENV LANG="C.UTF-8"
    
    # Install basic build tools
    RUN apt-get update \
        && apt-get upgrade -y \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
            make \
            unzip \
            # The tools in this package are used when installing packages for Python
            build-essential \
            swig \
            # Required for Microsoft SQL Server
            unixodbc-dev \
            # Required for PostgreSQL
            libpq-dev \
            # Required for mysqlclient
            default-libmysqlclient-dev \
            # Required for ts
            moreutils \
            rsync \
            zip \
            libgdiplus \
            jq \
            # By default pip is not available in the buildpacks image
            python3-pip \
            #.NET Core related pre-requisites
            libc6 \
            libgcc1 \
            libgssapi-krb5-2 \
            libncurses6 \
            liblttng-ust-dev \
            libssl-dev \
            libstdc++6 \
            zlib1g \
            libuuid1 \
            libunwind8 \
            sqlite3 \
            libsqlite3-dev \
            tk-dev \
            uuid-dev \
            curl \
            gettext \
            inotify-tools \
            # deb tools
            devscripts \
            equivs \
            ninja-build \
        && rm -rf /var/lib/apt/lists/* \
        # This is the folder containing 'links' to benv and build script generator
        && apt-get update \
        && apt-get upgrade -y \
        && bash /tmp/scripts/change_source.sh \
        && rm -rf /var/lib/apt/lists/*
    
    # Verify expected build and debug tools are present
    RUN apt-get update \
        && apt-get -y install build-essential cmake cppcheck valgrind clang lldb llvm gdb python3-dev \
        # Install tools and shells not in common script
        && apt-get install -yq vim vim-doc xtail libsecret-1-dev \
        # Install additional tools (useful for 'puppeteer' project)
        && apt-get install -y --no-install-recommends libnss3 libnspr4 libatk-bridge2.0-0 libatk1.0-0 libx11-6 libpangocairo-1.0-0 \
                                                      libx11-xcb1 libcups2 libxcomposite1 libxdamage1 libxfixes3 libpango-1.0-0 libgbm1 libgtk-3-0 \
        # Clean up
        && apt-get autoremove -y && apt-get clean -y \
        # Move first run notice to right spot
        && mkdir -p "/usr/local/etc/vscode-dev-containers/" \
        && mv -f /tmp/scripts/first-run-notice.txt /usr/local/etc/vscode-dev-containers/
    
    # Default to bash shell (other shells available at /usr/bin/fish and /usr/bin/zsh)
    ENV SHELL=/bin/bash \
        DOCKER_BUILDKIT=1
    
    # Install and setup fish
    RUN apt-get install -yq fish \
        && FISH_PROMPT="function fish_prompt\n    set_color green\n    echo -n (whoami)\n    set_color normal\n    echo -n \":\"\n    set_color blue\n    echo -n (pwd)\n    set_color normal\n    echo -n \"> \"\nend\n" \
        && printf "$FISH_PROMPT" >> /etc/fish/functions/fish_prompt.fish \
        && printf "if type code-insiders > /dev/null 2>&1; and not type code > /dev/null 2>&1\n  alias code=code-insiders\nend" >> /etc/fish/conf.d/code_alias.fish
    
    
    # Mount for docker-in-docker 
    VOLUME [ "/var/lib/docker" ]
    
    # Fire Docker/Moby script if needed
    ENTRYPOINT [ "/usr/local/share/docker-init.sh", "/usr/local/share/ssh-init.sh"]
    CMD [ "sleep", "infinity" ]
    
    # [Optional] Install debugger for development of Codespaces - Not in resulting image by default
    ARG DeveloperBuild
    RUN if [ -z $DeveloperBuild ]; then \
            echo "not including debugger" ; \
        else \
            curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v latest -l /vsdbg ; \
        fi

    RUN echo "deb [trusted=yes] https://download.opensuse.org/repositories/home:/elysia:/LingmoOS:/CI/Debian_Testing/ ./" > /etc/apt/sources.list.d/lingmo-nightly.list
    RUN curl -o /etc/apt/trusted.gpg.d/lingmo-nightly-signing.key.asc --create-dirs https://build.opensuse.org/projects/home:elysia:LingmoOS:CI/signing_keys/download?kind=gpg 

    # Setup noVNC
    # Install git, supervisor, VNC, & X11 packages
    RUN set -ex; \
        apt-get update; \
        apt-get install -y \
        bash \
        fluxbox \
        git \
        net-tools \
        novnc \
        supervisor \
        x11vnc \
        xterm \
        xvfb   

        # Setup demo environment variables
    ENV HOME=/home/codespace \
        DEBIAN_FRONTEND=noninteractive \
        LANG=en_US.UTF-8 \
        LANGUAGE=en_US.UTF-8 \
        LC_ALL=C.UTF-8 \
        DISPLAY=:0.0 \
        DISPLAY_WIDTH=1024 \
        DISPLAY_HEIGHT=768 \
        RUN_XTERM=yes \
        RUN_FLUXBOX=yes
    COPY docker-novnc /app
    COPY docker-novnc/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
    EXPOSE 8080

    # Remove scripts now that we're done with them
    RUN apt-get clean -y && rm -rf /tmp/scripts
