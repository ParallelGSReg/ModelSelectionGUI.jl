FROM --platform=linux/amd64 julia:1.9.1

RUN mkdir /app
WORKDIR /app
COPY Project.toml /app/
RUN mkdir /app/src
RUN echo "" > /app/src/ModelSelectionGUI.jl
RUN julia -e 'using Pkg; Pkg.activate("."); Pkg.instantiate();'
RUN rm /app/src/ModelSelectionGUI.jl
COPY . /app
RUN julia -e "using Pkg; Pkg.precompile(); "

RUN chmod +x /app/bin/repl
RUN chmod +x /app/bin/server
RUN chmod +x /app/bin/runtask

ENV GENIE_HOST "0.0.0.0"
ENV PORT "8000"
ENV WSPORT "8000"
ENV EARLYBIND "true"

CMD ["sh", "/app/bin/server"]
