SELECT id,
       AI_GENERATE_EMBEDDINGS(large_text USE MODEL MyAzureOpenAIModel)
  FROM myTable;

UPDATE t
   SET myEmbeddings = AI_GENERATE_EMBEDDINGS(t.text USE MODEL MyAzureOpenAIModel)
  FROM myTable AS t;

DECLARE @params JSON = N'{"dimensions":768}';
SELECT id,
       AI_GENERATE_EMBEDDINGS(large_text USE MODEL MyAzureOpenAIModel PARAMETERS @params)
  FROM myTable;
