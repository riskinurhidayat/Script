CREATE OR REPLACE PROCEDURE clar.Pr_insert_DIS(p_disid       in NUMBER,
                                          p_appHeaderID IN NUMBER,
                                          p_message     OUT VARCHAR2) IS

BEGIN
  INSERT INTO clar.wf_wfattachment
    (ID_ATTACHMENT, APPHEADERID, DIS_ID)
  VALUES
    (clar.SEQ_WF_WFATTACHMENT.NEXTVAL, p_appHeaderID, p_disid);
  p_message := 'ok';
EXCEPTION
  WHEN OTHERS THEN
    p_message := 'ERROR Pr_insert_DIS ' || SQLERRM;

    ROLLBACK;
END;
/
