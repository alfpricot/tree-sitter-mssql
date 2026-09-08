CREATE FUNCTION dbo.example_calc_total (@calc_type calc_type_type,
                                        @key_id key_id_type,
                                        @sub_key sub_key_type,
                                        @rate rate_type)
RETURNS amount_type
AS
BEGIN
    DECLARE @result amount_type,
            @temp    amount_type;
    SET @result = 0.0;
    IF @calc_type = N'A'
    BEGIN
        SELECT @result = SUM(t.cost)
          FROM detail AS t
         WHERE t.key_id  = @key_id
           AND t.sub_key = @sub_key;
    END;
    ELSE IF @calc_type = N'B'
        AND @sub_key = 1
    BEGIN
        SELECT @temp = SUM(t.cost)
          FROM detail AS t
          JOIN category AS c
            ON c.code = t.code
         WHERE t.key_id = @key_id;
        SET @result = @temp * (@rate * 0.01);
    END;
    ELSE IF (@calc_type = N'C')
        SELECT @result = SUM(t.cost)
          FROM detail AS t
         WHERE t.key_id = @key_id;
    ELSE IF (@calc_type = N'D')
    BEGIN
        IF @sub_key = 1
            SELECT @result = SUM(t.cost) + SUM(t.other_cost)
              FROM detail AS t
             WHERE t.key_id = @key_id;
        ELSE
            SELECT @result = SUM(t.cost)
              FROM detail AS t
             WHERE t.key_id = @key_id;
    END;
    IF @result IS NULL
        SET @result = 0.0;
    RETURN @result;
END;
