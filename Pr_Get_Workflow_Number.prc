CREATE OR REPLACE PROCEDURE Pr_Get_Workflow_Number(p_code        IN VARCHAR2,
                                                        p_workflow_no OUT VARCHAR2,
                                                        p_message     OUT VARCHAR2) IS
  v_seq   NUMBER := NULL;
  v_bulan VARCHAR2(3);
  v_tahun NUMBER;

BEGIN
  p_workflow_no := '0';
  begin
    SELECT (CASE wmw.bulan
             WHEN 'I' THEN
              'Jan'
             WHEN 'II' THEN
              'Feb'
             WHEN 'III' THEN
              'Mar'
             WHEN 'IV' THEN
              'Apr'
             WHEN 'V' THEN
              'May'
             WHEN 'VI' THEN
              'Jun'
             WHEN 'VII' THEN
              'Jul'
             WHEN 'VIII' THEN
              'Aug'
             WHEN 'IX' THEN
              'Sep'
             WHEN 'X' THEN
              'Oct'
             WHEN 'XI' THEN
              'Nov'
             WHEN 'XII' THEN
              'Dec'
           END)
      INTO v_bulan
      FROM clar.wf_master_wfprdefjob wmw
     WHERE wmw.code = p_code;
  EXCEPTION
    WHEN no_data_found THEN
      p_message := 'Job Salah';
  end;

  if (v_bulan <> TO_CHAR(SYSDATE, 'Mon')) then
    begin
      SELECT (CASE TO_CHAR(SYSDATE, 'Mon')
               WHEN 'Jan' THEN
                'I'
               WHEN 'Feb' THEN
                'II'
               WHEN 'Mar' THEN
                'III'
               WHEN 'Apr' THEN
                'IV'
               WHEN 'May' THEN
                'V'
               WHEN 'Jun' THEN
                'VI'
               WHEN 'Jul' THEN
                'VII'
               WHEN 'Aug' THEN
                'VIII'
               WHEN 'Sep' THEN
                'IX'
               WHEN 'Oct' THEN
                'X'
               WHEN 'Nov' THEN
                'XI'
               WHEN 'Dec' THEN
                'XII'
             END)
        INTO v_bulan
        FROM dual;

      UPDATE WF_MASTER_WFPRDEFJOB wmw
         SET SEQNUMBER        = 0,
             BULAN            = v_bulan,
             TAHUN            = TO_CHAR(SYSDATE, 'YY'),
             LASTMODIFIEDDATE = SYSDATE
       WHERE wmw.code = p_code;
    EXCEPTION
      WHEN OTHERS THEN
        p_message := 'ERROR Pr_Get_Workflow_Number' || SQLERRM;
        ROLLBACK;

    END;
  end if;

  begin
    SELECT wmw.seqnumber, wmw.bulan, wmw.tahun
      INTO v_seq, v_bulan, v_tahun
      FROM clar.wf_master_wfprdefjob wmw
     WHERE wmw.code = p_code;
  EXCEPTION
    WHEN no_data_found THEN
      p_message := 'Job Salah';
  end;

  IF v_seq IS NOT NULL THEN
    begin
      p_workflow_no := (v_seq + 1) || '/' || p_code || '/' || v_bulan || '/' ||
                       v_tahun;

      UPDATE clar.wf_master_wfprdefjob wmw
         SET wmw.seqnumber = v_seq + 1
       WHERE wmw.code = p_code;

      p_message := 'ok';

    EXCEPTION
      WHEN OTHERS THEN
        p_message := 'ERROR Pr_Get_Workflow_Number ' || SQLERRM;
        ROLLBACK;
    END;
  else
    p_message := 'Job Salah';
  END IF;

END;

 
/
