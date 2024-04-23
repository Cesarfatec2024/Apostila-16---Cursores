CREATE TABLE tb_top_youtubers(
cod_top_youtubers SERIAL PRIMARY KEY,
rank INT,
youtuber VARCHAR(200),
subscribers INT,
video_views VARCHAR(200),
video_count INT,
category VARCHAR(200),
started INT
);

SELECT * FROM tb_top_youtubers;


-- Exercício 1.1
DO $$
DECLARE
    -- Definindo variáveis
    v_rank INT;
    v_youtuber VARCHAR(200);
    v_video_count INT := 1000;
    v_category VARCHAR(200) := 'Sports'; 
--	v_category VARCHAR(200) := 'Music';
    tupla RECORD;
    resultado TEXT DEFAULT '';
BEGIN
    -- Definindo o cursor com a condição especificada
    FOR tupla IN
        SELECT rank, youtuber
        FROM tb_top_youtubers
        WHERE video_count >= v_video_count
        AND category = v_category
    LOOP
        -- Concatenando os valores das variáveis ao resultado
        resultado := resultado || tupla.rank || ': ' || tupla.youtuber || ', ';
    END LOOP;

    -- Exibindo o resultado
    RAISE NOTICE '%', resultado;
END;
$$


-- Exercício 1.2
DO $$
DECLARE
    youtuber_name VARCHAR(200);
    youtuber_rec RECORD;
    cur_top_youtubers CURSOR FOR
        SELECT youtuber
        FROM tb_top_youtubers
        ORDER BY cod_top_youtubers ASC; -- Ordenar em ordem não reversa
BEGIN
    -- Abrir o cursor
    OPEN cur_top_youtubers;

    -- Mover para a última linha do cursor
    FETCH LAST FROM cur_top_youtubers INTO youtuber_rec;

    -- Loop para iterar de baixo para cima
    WHILE FOUND LOOP
        -- Obter o nome do youtuber
        youtuber_name := youtuber_rec.youtuber;

        -- Exibir o nome do youtuber
        RAISE NOTICE 'Youtuber: %', youtuber_name;

        -- Mover para a linha anterior
        FETCH PRIOR FROM cur_top_youtubers INTO youtuber_rec;
    END LOOP;

    -- Fechar o cursor
    CLOSE cur_top_youtubers;
END $$;


-- Exercício 1.3

-- Pesquisa sobre o Anti-pattern RBAR
-- O termo RBAR significa "Row By Agonizing Row" (em português, "Linha Por Linha Agonizante"). Ele é considerado um anti-pattern. Um anti-pattern são más práticas que se não evitadas podem causar problemas de desempenho ou dificuldades de manutenção no software desenvolvido. E no caso do RBAR, ele é sempre associado ao mau uso de loops em SQL, especialmente em consultas a bancos de dados relacionais.
-- O RBAR ocorre principalmente quando um desenvolvedor utiliza loops explícitos (como loops WHILE ou FOR) para manipular linhas de dados individualmente em uma consulta SQL, em vez de aproveitar as capacidades de conjunto (set-based) da linguagem SQL. Em vez de aproveitar as operações de conjunto do SQL, como SELECT, JOIN, GROUP BY e agregações, o RBAR manipula cada linha de dados individualmente, o que pode levar a um desempenho ruim e ineficiente, especialmente em grandes conjuntos de dados.
-- No exemplo abaixo, podemos ver que o código utiliza um loop WHILE para percorrer sobre cada linha da tabela Table e atualizar o status de cada linha para 'Concluído'. Esse tipo de solução manipula cada linha individualmente, o que é bem ineficiente em comparação com uma única operação de atualização em conjunto que poderia ser realizada em uma única consulta SQL.
-- Exemplo de código:
-- DECLARE @i INT
-- SET @i = 1
-- WHILE @i <= (SELECT MAX(ID) FROM Table)
-- BEGIN
--    UPDATE Table SET Status = 'Concluído' WHERE ID = @i
--    SET @i = @i + 1
-- END
-- Portanto, podemos concluir que o RBAR é um anti-pattern que deve ser evitado ao máximo ao escrever consultas SQL. Em vez de manipular linhas de dados individualmente usando loops, os desenvolvedores devem procurar aproveitar as capacidades de conjunto do SQL para escrever consultas mais eficientes e fáceis de compreender. Isso vai resultar em um melhor desempenho, menor complexidade e maior escalabilidade das consultas no SQL.



