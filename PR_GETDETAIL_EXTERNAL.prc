CREATE OR REPLACE PROCEDURE PR_GETDETAIL_EXTERNAL(P_BRID   VARCHAR2,
                                                       P_NPK    VARCHAR2,
                                                       P_STATUS VARCHAR2,
                                                       P_MOUNO  VARCHAR2,
                                                       P_RCOUT  OUT CLAR.PG_GLOBAL.RC_UNIVERSAL) IS
BEGIN
  IF P_STATUS = '1' THEN
    --RECO = 1
    BEGIN
      OPEN P_RCOUT FOR
        SELECT ME.MOU_ID_CATEGORY P_COMP_TYPE,
               PE.EMPL_BANK_ID P_BANK_ID,
               ' ' AS P_BANK_NAME,
               PE.EMPL_BANK_ACC_NO P_BANK_ACC_NO,
               PE.EMPL_BANK_ACC_NAME P_BANK_ACC_NAME,
               ' ' AS P_BANK_BRANCH,
               PE.TAX_ID P_ID_TAX,
               PE.TAX_FLAG AS P_TAXFLAG,
               PE.TAX_PPN AS P_PPNFLAG,
               PE.TAX_SIUJK AS P_SIUJKFLAG,
               PE.STATUS_DETAIL AS P_STATUS_DETAIL,
               TRIM(MT.NPK) AS P_SHADOWPT_NPK,
               MT.BRANCHID AS P_SHADOWPT_BRID_NPK,
               MT.TAX_ID AS P_SHADOWPT_IDTAX,
               MT.TAX_FLAG AS P_SHADOWPT_TAXFLAG,
               MT.TAX_PPN AS P_SHADOWPT_PPNFLAG,
               MT.TAX_SIUJK AS P_SHADOWPT_SIUJKFLAG,
               MT.EMPL_BANK_ID AS P_SHADOWPT_BANK_ID,
               '' AS P_SHADOWPT_BANK_NAME,
               MT.EMPL_BANK_ACC_NAME AS P_SHADOWPT_BANK_ACC_NAME,
               MT.EMPL_BANK_ACC_NO AS P_SHADOWPT_BANK_ACC_NO,
               '' AS P_SHADOWPT_BANK_BRANCH,
               MT.STATUS_DETAIL AS P_SHADOWPT_STATUSDETAIL
          FROM CLAR.PARA_EXA_REC PE
         INNER JOIN CLAR.MOU_EXA_REC ME
            ON ME.MOU_NO = PE.MOU_NO
          LEFT JOIN (SELECT PR.*
                       FROM CLAR.MOU_EXA_REC MR, CLAR.PARA_EXA_REC PR
                      WHERE MR.MOU_NO = PR.MOU_NO
                        AND MR.MOU_NO = P_MOUNO
                        AND PR.STATUS_DETAIL = '0'
                        AND MR.MOU_ACTIVE = '1'
                        AND PR.AKTIF = '1') MT
            ON MT.MOU_NO = PE.MOU_NO
         WHERE PE.AKTIF = '1'
           AND ME.MOU_ACTIVE = '1'
           AND TRIM(PE.NPK) = P_NPK
           AND PE.BRANCHID = P_BRID;
    END;
  ELSE
    --COLL = 2
    BEGIN
      OPEN P_RCOUT FOR
        SELECT A.COM_TYPE P_COMP_TYPE,
               B.EMPL_BANK_ID P_BANK_ID,
               B.EMPL_BANK_NAME P_BANK_NAME,
               B.EMPL_BANK_ACC_NO P_BANK_ACC_NO,
               B.EMPL_BANK_ACC_NAME P_BANK_ACC_NAME,
               B.EMPL_BANK_BRANCH P_BANK_BRANCH,
               B.TAX_ID P_ID_TAX,
               B.TAX_FLAG P_TAXFLAG,
               B.TAX_PPN P_PPNFLAG,
               B.TAX_SIUJK P_SIUJKFLAG,
               B.STATUS_DETAIL P_STATUS_DETAIL,
               TRIM(E.EMPL_NPK) P_SHADOWPT_NPK,
               E.EMPL_BRID P_SHADOWPT_BRID_NPK,
               E.TAX_ID P_SHADOWPT_IDTAX,
               E.TAX_FLAG P_SHADOWPT_TAXFLAG,
               E.TAX_PPN P_SHADOWPT_PPNFLAG,
               E.TAX_SIUJK P_SHADOWPT_SIUJKFLAG,
               E.EMPL_BANK_ID P_SHADOWPT_BANK_ID,
               E.EMPL_BANK_NAME P_SHADOWPT_BANK_NAME,
               E.EMPL_BANK_ACC_NAME P_SHADOWPT_BANK_ACC_NAME,
               E.EMPL_BANK_ACC_NO P_SHADOWPT_BANK_ACC_NO,
               E.EMPL_BANK_BRANCH P_SHADOWPT_BANK_BRANCH,
               E.STATUS_DETAIL P_SHADOWPT_STATUSDETAIL
          FROM CLAR.COLL_PARA_EXC_HEADER A, CLAR.COLL_PARA_EXC_DETAIL B
          LEFT JOIN (SELECT D.*
                       FROM CLAR.COLL_PARA_EXC_HEADER C,
                            CLAR.COLL_PARA_EXC_DETAIL D
                      WHERE C.COM_TYPE = '1'
                        AND C.DELETED = '0'
                        AND C.COM_MOU_NO = D.COM_MOU_NO
                        AND C.COM_MOU_NO = P_MOUNO
                        AND D.DELETED = '0'
                        AND D.STATUS_DETAIL = '0') E
            ON E.COM_MOU_NO = B.COM_MOU_NO
         WHERE A.COM_MOU_NO = B.COM_MOU_NO
           AND A.DELETED = '0'
           AND TRIM(B.EMPL_NPK) = P_NPK
           AND B.DELETED = '0'
           AND B.EMPL_BRID = P_BRID;
    END;
  END IF;
END;
/
