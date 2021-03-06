CREATE OR REPLACE PROCEDURE CLAR.PR_GETDECSCOLPNEG(P_ISDENDAREGULAR IN NUMBER,
                                                   P_JENISKENDARAAN IN VARCHAR2,
                                                   P_SELISIH        IN NUMBER,
                                                   P_WFLEVEL        OUT VARCHAR2,
                                                   P_MESSAGE        OUT VARCHAR2) IS
BEGIN
  BEGIN
    SELECT PAR.WFLEVEL
      INTO P_WFLEVEL
      FROM CLAR.WF_WFPARADECISIONCOLPNEG PAR
     WHERE PAR.JENISKENDARAAN = P_JENISKENDARAAN
       AND P_SELISIH BETWEEN PAR.SELISIHAWAL AND PAR.SELISIHAKHIR
       AND PAR.ISDENDAREGULAR <> 0 AND ROWNUM = 1;
  END;
  P_MESSAGE := 'OK';
EXCEPTION
  WHEN OTHERS THEN
    P_MESSAGE := 'ERROR PR_GETDECSCOLPNEG' || SQLERRM;
    ROLLBACK;
END;