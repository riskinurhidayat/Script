CREATE OR REPLACE PROCEDURE CLAR.PR_GETDECSCOLDISC(P_JENISKENDARAAN IN VARCHAR2,
                                              P_SELISIH        IN NUMBER,
                                              P_WFLEVEL        OUT VARCHAR2,
                                              P_MESSAGE        OUT VARCHAR2) IS
BEGIN
  SELECT PAR.WFLEVEL
    INTO P_WFLEVEL
    FROM CLAR.WF_WFPARADECISIONCOLDISC PAR
   WHERE PAR.JENISKENDARAAN = P_JENISKENDARAAN
     AND P_SELISIH BETWEEN PAR.SELISIHAWAL AND PAR.SELISIHAKHIR
     AND ROWNUM = 1;

  P_MESSAGE := 'OK';
EXCEPTION
  WHEN OTHERS THEN
    P_MESSAGE := 'ERROR PR_GETDECSCOLDISC' || SQLERRM;
    ROLLBACK;
END;