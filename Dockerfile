FROM datasetteproject/datasette AS build
COPY data ./data
RUN pip install xlsx2csv csvs-to-sqlite
RUN xlsx2csv -aim data/Railway-Work-Life-Death-database.xlsx data
RUN csvs-to-sqlite data/*.csv data.db
RUN datasette inspect data.db --inspect-file inspect-data.json

FROM datasetteproject/datasette
WORKDIR /app

COPY --from=build /github/workspace/data.db .
COPY --from=build /github/workspace/inspect-data.json .
COPY metadata.json .
COPY templates ./templates
COPY static ./static

CMD ["datasette", "serve", \
	"./data.db", "--host", "0.0.0.0", "--port", "$PORT", \
	"--template-dir", "./templates", \
	"--static=static:./static", \
	"--inspect-file", "./inspect-data.json", \
        "--metadata", "./metadata.json"]
