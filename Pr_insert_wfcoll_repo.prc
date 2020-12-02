CREATE OR REPLACE PROCEDURE Pr_insert_wfcoll_repo(p_issubmit             IN VARCHAR2,
                                                  p_initiatornik         IN VARCHAR2,
                                                  p_initiatorname        IN VARCHAR2,
                                                  p_nokontrak            IN VARCHAR2,
                                                  p_cabang               IN VARCHAR2,
                                                  p_namacustomer         IN VARCHAR2,
                                                  p_isDendaReguler       IN NUMBER,
                                                  p_PosisiOD             IN NUMBER,
                                                  p_penaltyPelunasan     IN NUMBER,
                                                  p_sisaPokokHutang      IN NUMBER,
                                                  p_interestPP           IN NUMBER,
                                                  p_tunggakananggsuran   IN NUMBER,
                                                  p_tunggakandenda       IN NUMBER,
                                                  p_biayaAdmin           IN NUMBER,
                                                  p_biayaTarik           IN NUMBER,
                                                  p_jumlahBayar          IN NUMBER,
                                                  p_estimasihargajual    IN NUMBER,
                                                  p_namaEksternal        IN VARCHAR2,
                                                  p_isUnit               IN NUMBER,
                                                  p_isNasabah            IN NUMBER,
                                                  p_isPemegangUnit       IN NUMBER,
                                                  p_lokasiUnit           IN VARCHAR2,
                                                  p_JarakDariKantor      IN NUMBER,
                                                  p_Keterangan           IN Varchar2,
                                                  p_jenisKendaraan       IN Varchar2,
                                                  p_namaOnBPKB           IN VARCHAR2,
                                                  p_Merk                 IN VARCHAR2,
                                                  p_type                 IN VARCHAR2,
                                                  p_tahun                IN VARCHAR2,
                                                  p_noRangka             IN VARCHAR2,
                                                  p_noMesin              IN VARCHAR2,
                                                  p_tipeWorkflow         IN VARCHAR2,
                                                  p_brIdEksternal        IN VARCHAR2,
                                                  p_NPKEksternal         IN VARCHAR2,
                                                  p_NOMOU                IN VARCHAR2,
                                                  p_appHeaderID          IN NUMBER,
                                                  p_disid                in NUMBER,
                                                  p_KETERANGANKEKURANGAN IN VARCHAR2,
                                                  p_noSK                 IN VARCHAR2,
                                                  p_cabangInitiator      IN Varchar2,
                                                  p_message              OUT VARCHAR2) IS

BEGIN
  IF p_issubmit = '0' then
    --revisi
    update CLAR.WF_WFCOLLECTION
       set ISACTIVE = 0
     WHERE APPHEADERID = p_appheaderid
       and ISACTIVE = 1;
  ELSIF p_issubmit = '1' then
    --create
    IF p_disid <> '0' then
      INSERT INTO clar.wf_wfattachment
        (ID_ATTACHMENT, APPHEADERID, DIS_ID)
      VALUES
        (clar.SEQ_WF_WFATTACHMENT.NEXTVAL, p_appHeaderID, p_disid);
    END if;
  END IF;
  INSERT INTO CLAR.WF_WFCOLLECTION
    (IDCOLLECTION,
     APPHEADERID,
     ISACTIVE,
     CREATEDATE,
     CREATEUSERNIK,
     CREATEUSERNAME,
     NOKONTRAK,
     CABANG,
     NAMACUSTOMER,
     ISDENDAREGULER,
     POSISIOD,
     PENALTYPELUNASAN,
     SISAPOKOKHUTANG,
     INTERESTPP,
     TUNGGAKANANGSURAN,
     TUNGGAKANDENDA,
     BIAYAADMIN,
     BIAYATARIK,
     JUMLAHBAYAR,
     ESTIMASIHARGAJUAL,
     NAMAEKSTERNAL,
     ISUNIT,
     ISNASABAH,
     ISPEMEGANGUNIT,
     LOKASIUNIT,
     JARAKDARIKANTOR,
     KETERANGAN,
     JENISKENDARAAN,
     NAMAONBPKB,
     MERK,
     TYPE,
     TAHUN,
     NORANGKA,
     NOMESIN,
     TIPEWORKFLOW,
     BRIDEKSTERNAL,
     NPKEKSTERNAL,
     NOMOU,
     KETERANGANKEKURANGAN,
     NOSK,
     CABANGINITITATOR)
  VALUES
    (CLAR.Seq_Wf_Wfcollection.NEXTVAL,
     p_appHeaderID,
     1,
     SYSDATE,
     p_initiatornik,
     p_initiatorname,
     p_nokontrak,
     p_cabang,
     p_namacustomer,
     p_isDendaReguler,
     p_PosisiOD,
     p_penaltyPelunasan,
     p_sisaPokokHutang,
     p_interestPP,
     p_tunggakananggsuran,
     p_tunggakandenda,
     p_biayaAdmin,
     p_biayaTarik,
     p_jumlahBayar,
     p_estimasihargajual,
     p_namaEksternal,
     p_isUnit,
     p_isNasabah,
     p_isPemegangUnit,
     p_lokasiUnit,
     p_JarakDariKantor,
     p_Keterangan,
     p_jenisKendaraan,
     p_namaOnBPKB,
     p_Merk,
     p_type,
     p_tahun,
     p_noRangka,
     p_noMesin,
     p_tipeWorkflow,
     p_brIdEksternal,
     p_NPKEksternal,
     p_NOMOU,
     p_KETERANGANKEKURANGAN,
     p_noSK,
     p_cabangInitiator);

  p_message := 'ok';

EXCEPTION
  WHEN OTHERS THEN
    p_message := 'ERROR Pr_insert_wfcoll ' || SQLERRM;
  
    ROLLBACK;
END Pr_insert_wfcoll_repo;
