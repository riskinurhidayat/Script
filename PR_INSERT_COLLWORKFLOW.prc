CREATE OR REPLACE PROCEDURE APP_CLAR.PR_INSERT_COLLWORKFLOW(P_BR_ID           IN VARCHAR2,
                                                            P_PICKUP_NO       IN VARCHAR2,
                                                            P_CONT_NO         IN VARCHAR2,
                                                            P_BR_ID_LOGIN     IN VARCHAR2,
                                                            P_CODE_REP        IN VARCHAR2,
                                                            P_BR_ID_CODE_REP  IN VARCHAR2,
                                                            P_COM_NPK         IN VARCHAR2,
                                                            P_AMOUNT          IN NUMBER,
                                                            P_WORKFLOW_FLAG   IN VARCHAR2,
                                                            P_WORKFLOW_STATUS IN VARCHAR2,
                                                            P_WORKFLOW_NO     IN VARCHAR2,
                                                            P_WORKFLOW_AMT    IN NUMBER,
                                                            P_PV_NO           IN VARCHAR2,
                                                            P_RV_NO           IN VARCHAR2,
                                                            P_CONT_STATUS     IN VARCHAR2,
                                                            P_AMOUNT_TAX      IN NUMBER,
                                                            P_FLAG_RV         IN VARCHAR2,
                                                            P_STATUS_PAID     IN VARCHAR2,
                                                            P_MESSAGE         OUT VARCHAR2) AS
BEGIN
  INSERT INTO APP_CLAR.COLL_WORKFLOW
    (BR_ID,
     PICKUP_NO,
     CONT_NO,
     BR_ID_LOGIN,
     CODE_REP,
     BR_ID_CODE_REP,
     COM_NPK,
     AMOUNT,
     TGL_SYSDATE,
     WORKFLOW_FLAG,
     WORKFLOW_STATUS,
     WORKFLOW_STATUS_DATE,
     WORKFLOW_NO,
     WORKFLOW_AMT,
     PV_NO,
     RV_NO,
     CONT_STATUS,
     AMOUNT_TAX,
     FLAG_RV,
     STATUS_PAID)
  VALUES
    (P_BR_ID,
     P_PICKUP_NO,
     P_CONT_NO,
     P_BR_ID_LOGIN,
     P_CODE_REP,
     P_BR_ID_CODE_REP,
     P_COM_NPK,
     P_AMOUNT,
     SYSDATE,
     P_WORKFLOW_FLAG,
     P_WORKFLOW_STATUS,
     SYSDATE,
     P_WORKFLOW_NO,
     P_WORKFLOW_AMT,
     P_PV_NO,
     P_RV_NO,
     P_CONT_STATUS,
     P_AMOUNT_TAX,
     P_FLAG_RV,
     P_STATUS_PAID);

  P_MESSAGE := 'ok';

EXCEPTION
  WHEN OTHERS THEN
    P_MESSAGE := 'ERROR PR_INSERT_COLLWORKFLOW ' || SQLERRM;
    ROLLBACK;
END PR_INSERT_COLLWORKFLOW;
