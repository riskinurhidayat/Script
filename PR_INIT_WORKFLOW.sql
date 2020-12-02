CREATE OR REPLACE PROCEDURE PR_INIT_WORKFLOW(P_INSTANCEID        IN NUMBER,
                                             P_CODE              IN VARCHAR2,
                                             P_REQUESTNO         IN VARCHAR2,
                                             P_INITIATORNAME     IN VARCHAR2,
                                             P_OWNERJABATANNAME  IN VARCHAR2,
                                             P_LOCATIONNAME      IN VARCHAR2,
                                             P_SUBJECT           IN VARCHAR2,
                                             P_INITIATORNIK      IN VARCHAR2,
                                             P_OWNERJABATANCODE  IN VARCHAR2,
                                             P_LOCATIONCODE      IN VARCHAR2,
                                             P_NOTE              IN VARCHAR2,
                                             P_INITIATORROLENAME IN VARCHAR2,
                                             P_INITIATORTASKID   IN NUMBER,
                                             P_NEXTROLENAME      IN VARCHAR2,
                                             P_NEXTTASKID        IN NUMBER,
                                             P_ROLEALIAS         IN VARCHAR2,
                                             P_NEXTROLEALIAS     IN VARCHAR2,
                                             P_NEXTLOCATIONALIAS IN VARCHAR2,
                                             P_NEXTLOCATIONNAME  IN VARCHAR2,
                                             P_STATUS            IN VARCHAR2,
                                             P_MESSAGE           OUT VARCHAR2,
                                             P_APPHEADERID       OUT NUMBER) IS
BEGIN
  DECLARE
    P_APPROVALID NUMBER;
  
  BEGIN
    --INSERT WF_WFHEADER
    P_APPHEADERID := CLAR.SEQ_WF_WFHEADER.NEXTVAL;
    INSERT INTO CLAR.WF_WFHEADER
      (APPHEADERID,
       CODE,
       REQUESTNO,
       STATUS,
       INITIATORNIK,
       INITIATORNAME,
       SUBJECT,
       CREATEDATE,
       INSTANCE_ID)
    VALUES
      (P_APPHEADERID,
       P_CODE,
       P_REQUESTNO,
       0,
       P_INITIATORNIK,
       P_INITIATORNAME,
       P_SUBJECT,
       SYSDATE,
       P_INSTANCEID);
  
    --INSERT WF_WFAPPROVAL FOR INITIATOR
    P_APPROVALID := CLAR.SEQ_WF_WFAPPROVAL.NEXTVAL;
    INSERT INTO CLAR.WF_WFAPPROVAL
      (APPROVALID,
       APPHEADERID,
       ISACTIVE,
       STATUS,
       OWNERNAME,
       OWNERJABATANNAME,
       LOCATIONNAME,
       OWNERNIK,
       OWNERJABATANCODE,
       LOCATIONCODE,
       APPROVALTYPE,
       DATEIN,
       DATENOTICE,
       DATEOUT,
       NOTE)
    VALUES
      (P_APPROVALID,
       P_APPHEADERID,
       0,
       P_STATUS,
       P_INITIATORNAME,
       P_OWNERJABATANNAME,
       P_LOCATIONNAME,
       P_INITIATORNIK,
       P_OWNERJABATANCODE,
       P_LOCATIONCODE,
       0,
       SYSDATE,
       SYSDATE,
       SYSDATE,
       P_NOTE);
  
    --INSERT WF_WFAPPROVAL_ROLE FOR INITIATOR
    INSERT INTO CLAR.WF_WFAPPROVAL_ROLE
      (ROLEID, APPROVALID, ROLEALIAS, ROLENAME, TASKID)
    VALUES
      (CLAR.SEQ_WF_WFAPPROVAL_ROLE.NEXTVAL,
       P_APPROVALID,
       P_ROLEALIAS,
       P_INITIATORROLENAME,
       P_INITIATORTASKID);
  
    --INSERT WF_WFAPPROVAL FOR NEXT APPROVAL
    P_APPROVALID := CLAR.SEQ_WF_WFAPPROVAL.NEXTVAL;
    INSERT INTO CLAR.WF_WFAPPROVAL
      (APPROVALID,
       APPHEADERID,
       ISACTIVE,
       STATUS,
       OWNERNAME,
       OWNERJABATANNAME,
       LOCATIONNAME,
       OWNERNIK,
       OWNERJABATANCODE,
       LOCATIONCODE,
       APPROVALTYPE,
       DATEIN,
       DATENOTICE,
       DATEOUT,
       NOTE)
    VALUES
      (P_APPROVALID,
       P_APPHEADERID,
       1,
       'Waiting',
       '-',
       '-',
       P_NEXTLOCATIONNAME,
       '-',
       '-',
       P_NEXTLOCATIONALIAS,
       0,
       SYSDATE,
       '',
       '',
       '-');
  
    --INSERT WF_WFAPPROVAL_ROLE FOR NEXT APPROVAL
    INSERT INTO CLAR.WF_WFAPPROVAL_ROLE
      (ROLEID, APPROVALID, ROLEALIAS, ROLENAME, TASKID)
    VALUES
      (CLAR.SEQ_WF_WFAPPROVAL_ROLE.NEXTVAL,
       P_APPROVALID,
       P_NEXTROLEALIAS,
       P_NEXTROLENAME,
       P_NEXTTASKID);
  
  END;

  P_MESSAGE := 'OK';
EXCEPTION
  WHEN OTHERS THEN
    P_MESSAGE := 'ERROR PR_INIT_WORKFLOW' || SQLERRM;
    ROLLBACK;
END;
