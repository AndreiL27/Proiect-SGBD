SET SERVEROUTPUT ON
DECLARE
v_id_bilet NUMBER(3) := &id;
BEGIN
EXECUTE IMMEDIATE 'DELETE FROM BILETE WHERE Id_bilet = :id' USING v_id_bilet;

IF SQL%ROWCOUNT = 0 THEN
RAISE_APPLICATION_ERROR(-20001, 'Biletul cu ID-ul introdus nu exista in tabela BILETE.');
ELSE
DBMS_OUTPUT.PUT_LINE('Biletul cu ID-ul ' || v_id_bilet || ' a fost sters din tabela BILETE.');
END IF;
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/



DECLARE
v_id_tara TARI_2.Id_tara%TYPE := 'RO';
v_numar_curse INTEGER := 0;
BEGIN
IF v_id_tara IS NOT NULL THEN
SELECT COUNT(*)
INTO v_numar_curse
FROM CURSE c
INNER JOIN AEROPORTURI ap ON c.Aeroport_plecare = ap.Nume_aeroport
INNER JOIN TARI_2 t ON ap.Id_tara = t.Id_tara
WHERE t.Id_tara = v_id_tara;
DBMS_OUTPUT.PUT_LINE('Numarul de curse care pleaca din Romania: ' || v_numar_curse);
END IF;
END;
/



DECLARE
v_tara VARCHAR2(5) := 'RO'; 
v_aeroport VARCHAR2(200);
CURSOR c_aeroporturi IS
SELECT Nume_aeroport
FROM AEROPORTURI a
JOIN TARI_2 t ON a.Id_tara = t.Id_tara
WHERE t.Id_tara = v_tara;
BEGIN
OPEN c_aeroporturi;
LOOP
FETCH c_aeroporturi INTO v_aeroport;
EXIT WHEN c_aeroporturi%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(v_aeroport);
END LOOP;
CLOSE c_aeroporturi;
END;
/



DECLARE
v_pasager VARCHAR2(200) := 'Popescu'; 
v_zbor VARCHAR2(200);
v_pret NUMBER(4);
CURSOR c_bilete IS
SELECT z.Nume_zbor, b.Pret
FROM BILETE b
JOIN PASAGERI p ON b.Id_pasager = p.Id_pasager
JOIN ZBORURI z ON b.Id_zbor = z.Id_zbor
WHERE p.Nume_pasager = v_pasager;
BEGIN
OPEN c_bilete;
LOOP
FETCH c_bilete INTO v_zbor, v_pret;
EXIT WHEN c_bilete%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(v_zbor || ' - ' || TO_CHAR(v_pret, 'FM9999'));
END LOOP;
CLOSE c_bilete;
END;
/



DECLARE
TYPE pasageri_tab IS TABLE OF PASAGERI%ROWTYPE INDEX BY PLS_INTEGER;
t_pasageri pasageri_tab;
BEGIN
SELECT *
BULK COLLECT INTO t_pasageri
FROM PASAGERI;

FOR i IN t_pasageri.FIRST..t_pasageri.LAST LOOP
DBMS_OUTPUT.PUT_LINE('Id pasager: ' || t_pasageri(i).Id_pasager ||' ||'|| ' Nume: ' || t_pasageri(i).Nume_pasager ||' ||'|| ' Prenume: ' || t_pasageri(i).Prenume_pasager);
END LOOP;
END;
/



DECLARE
  TYPE IdListType IS TABLE OF TARI_2.Id_tara%TYPE;
  IdList IdListType := IdListType();
  NumeTara TARI_2.Nume_tara%TYPE;
BEGIN
  SELECT Id_tara
  BULK COLLECT INTO IdList
  FROM TARI_2;
  FOR i IN 1..IdList.COUNT LOOP
    SELECT Nume_tara
    INTO NumeTara
    FROM TARI_2
    WHERE Id_tara = IdList(i);
    DBMS_OUTPUT.PUT_LINE('ID Tara: ' || IdList(i) || ', Nume Tara: ' || NumeTara);
  END LOOP;
END;
/



DECLARE
   TYPE PasagerListaType IS VARRAY(10) OF PASAGERI.Id_pasager%TYPE;
   PasagerLista PasagerListaType := PasagerListaType(201, 202, 203);
BEGIN
   FOR i IN 1..PasagerLista.COUNT LOOP
      INSERT INTO PASAGERI (Id_pasager, Nume_pasager, Prenume_pasager, Varsta_pasager)
      VALUES (PasagerLista(i), 'Nume Pasager ' || PasagerLista(i), 'Prenume Pasager ' || PasagerLista(i), 30);
   END LOOP;
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('Datele au fost inserate în tabela PASAGERI.');
END;
/



DECLARE
  TYPE IdListType IS TABLE OF TARI_2.Id_tara%TYPE;
  IdList IdListType := IdListType();
BEGIN
  -- Popul?m tabela temporar? cu ID-urile ??rilor
  SELECT Id_tara
  BULK COLLECT INTO IdList
  FROM TARI_2;

  -- Parcurgem tabela temporar? ?i afi??m ID-urile ??rilor
  FOR i IN 1..IdList.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('ID Tara: ' || IdList(i));
  END LOOP;
END;
/



DECLARE
  TYPE NameListType IS TABLE OF PASAGERI.Nume_pasager%TYPE;
  NameList NameListType := NameListType();
BEGIN
  SELECT Nume_pasager
  BULK COLLECT INTO NameList
  FROM PASAGERI;

  FOR i IN 1..NameList.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('Nume pasager: ' || NameList(i));
  END LOOP;
END;
/



BEGIN
  INSERT INTO TARI_2 (Id_tara, Nume_tara) VALUES ('RO', 'Romania');
  INSERT INTO TARI_2 (Id_tara, Nume_tara) VALUES ('US', 'United States');
  INSERT INTO TARI_2 (Id_tara, Nume_tara) VALUES ('FR', 'France');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Eroare la inserarea în tabela TARI_2: ' || SQLERRM);
END;
/



DECLARE
v_Nume_zbor CURSE.aeroport_plecare%TYPE;
BEGIN
  SELECT aeroport_plecare INTO v_Nume_zbor
  FROM CURSE
  WHERE Id_cursa = 100;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Nu exista o cursa cu ID-ul specificat.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Eroare la selectarea din tabela CURSE: ' || SQLERRM);
END;
/



BEGIN
    INSERT INTO TARI_2 (Id_tara, Nume_tara)
    VALUES ('RO', 'Romania');
    
    INSERT INTO AEROPORTURI (Id_aeroport, Nume_aeroport, Oras, Id_tara, Cod_aeroport)
    VALUES (1, 'Aeroportul Otopeni', 'Bucuresti', 'RO', 'OTP');
    
    INSERT INTO CURSE (Id_cursa, Aeroport_plecare, Aeroport_sosire, Durata_cursa, Id_companie)
    VALUES (1, 'OTP', 'CDG', 120, 1);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Eroare: Inserarea exista deja în una dintre tabele.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('A aparut o exceptie: ' || SQLERRM);
END;
/


DECLARE
  v_id_aeroport AEROPORTURI.Id_aeroport%TYPE := 1;
  v_id_tara AEROPORTURI.Id_tara%TYPE := 'DE';
BEGIN
  UPDATE AEROPORTURI
  SET Id_tara = v_id_tara
  WHERE Id_aeroport = v_id_aeroport;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Eroare: ID_aeroport inexistent în tabelul AEROPORTURI.');
END;
/



DECLARE
v_nume_membru ECHIPAJ.Nume_membru%TYPE;
BEGIN
SELECT Nume_membru INTO v_nume_membru
FROM ECHIPAJ
WHERE Id_membru = 111;
DBMS_OUTPUT.PUT_LINE('Membru echipaj gasit: ' || v_nume_membru);
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Membrul echipajului nu a fost gasit.');
END;
/



DECLARE
CURSOR cur_tari IS
SELECT Id_tara, Nume_tara
FROM TARI_2;   
CURSOR cur_aeroporturi(p_Id_tara VARCHAR2) IS
SELECT Id_aeroport, Nume_aeroport, Oras, Cod_aeroport
FROM AEROPORTURI
WHERE Id_tara = p_Id_tara;

   v_id_tara TARI_2.Id_tara%TYPE;
   v_nume_tara TARI_2.Nume_tara%TYPE;
   v_id_aeroport AEROPORTURI.Id_aeroport%TYPE;
   v_nume_aeroport AEROPORTURI.Nume_aeroport%TYPE;
   v_oras AEROPORTURI.Oras%TYPE;
   v_cod_aeroport AEROPORTURI.Cod_aeroport%TYPE;
BEGIN
OPEN cur_tari;
LOOP
FETCH cur_tari INTO v_id_tara, v_nume_tara;
EXIT WHEN cur_tari%NOTFOUND;
      
DBMS_OUTPUT.PUT_LINE('Tara: ' || v_nume_tara);
DBMS_OUTPUT.PUT_LINE('Aeroporturi:');
      
OPEN cur_aeroporturi(v_id_tara);
LOOP
FETCH cur_aeroporturi INTO v_id_aeroport, v_nume_aeroport, v_oras, v_cod_aeroport;
EXIT WHEN cur_aeroporturi%NOTFOUND;
         
DBMS_OUTPUT.PUT_LINE('   - ' || v_nume_aeroport || ', Oras: ' || v_oras || ', Cod: ' || v_cod_aeroport);
END LOOP;
      
CLOSE cur_aeroporturi;
      
DBMS_OUTPUT.PUT_LINE('');
END LOOP;
   
CLOSE cur_tari;
END;
/



DECLARE
CURSOR c_tari IS
SELECT Id_tara, Nume_tara
FROM TARI_2;
CURSOR c_aeroporturi(p_Id_tara VARCHAR2) IS
SELECT Id_aeroport, Nume_aeroport, Oras, Cod_aeroport
FROM AEROPORTURI
WHERE Id_tara = p_Id_tara;
BEGIN
FOR r IN c_tari LOOP
DBMS_OUTPUT.PUT_LINE('Tara: ' || r.Nume_tara);
DBMS_OUTPUT.PUT_LINE('Aeroporturi:');
FOR rec_aeroport IN c_aeroporturi(r.Id_tara) LOOP
DBMS_OUTPUT.PUT_LINE(' - ' || rec_aeroport.Nume_aeroport || ', Oras: ' || rec_aeroport.Oras || ', Cod: ' || rec_aeroport.Cod_aeroport);
END LOOP;
DBMS_OUTPUT.PUT_LINE('');
END LOOP;
END;
/



DECLARE
v_count NUMBER;
BEGIN
UPDATE TARI_2 SET Nume_tara = 'Bulgaria' WHERE Id_tara = 'RO';
v_count := SQL%ROWCOUNT;
IF v_count > 0 THEN
DBMS_OUTPUT.PUT_LINE('Au fost actualizate ' || v_count || ' înregistrari.');
ELSE
DBMS_OUTPUT.PUT_LINE('Nu s-au gasit înregistrari pentru actualizare.');
END IF;
END;
/



CREATE OR REPLACE FUNCTION calcul_durata_totala(p_id_companie IN COMPANII_AERIENE.Id_companie%TYPE)
RETURN NUMBER IS
v_durata_totala NUMBER(10) := 0;
BEGIN
SELECT SUM(c.Durata_cursa) INTO v_durata_totala
FROM COMPANII_AERIENE ca
JOIN CURSE c ON ca.Id_companie = c.Id_companie
WHERE ca.Id_companie = p_id_companie;
RETURN v_durata_totala;
END;
/

DECLARE
v_id_companie COMPANII_AERIENE.Id_companie%TYPE := 1;
v_durata_totala NUMBER(10);
BEGIN
v_durata_totala := calcul_durata_totala(v_id_companie);
DBMS_OUTPUT.PUT_LINE('Durata totala a curselor pentru compania cu ID-ul ' || v_id_companie || ': ' || v_durata_totala || ' minute');
END;
/



CREATE OR REPLACE FUNCTION numar_bilete(p_id_pasager IN PASAGERI.Id_pasager%TYPE)
RETURN NUMBER IS
v_numar_bilete NUMBER(10) := 0;
BEGIN
SELECT COUNT(*) INTO v_numar_bilete
FROM BILETE
WHERE Id_pasager = p_id_pasager;
RETURN v_numar_bilete;
END;
/

DECLARE
v_id_pasager PASAGERI.Id_pasager%TYPE := 2;
v_numar_bilete NUMBER(10);
BEGIN
v_numar_bilete := numar_bilete(v_id_pasager);
DBMS_OUTPUT.PUT_LINE('Numarul total de bilete achizitionate de pasagerul cu ID-ul ' || v_id_pasager || ': ' || v_numar_bilete);
END;
/




CREATE OR REPLACE FUNCTION actualizare_experienta(p_id_membru IN ECHIPAJ.Id_membru%TYPE, p_experienta_noua IN ECHIPAJ.Experienta%TYPE)
RETURN NUMBER IS
v_numar_membri_experienta_mare NUMBER(10) := 0;
BEGIN
UPDATE ECHIPAJ
SET Experienta = p_experienta_noua
WHERE Id_membru = p_id_membru;
SELECT COUNT(*) INTO v_numar_membri_experienta_mare
FROM ECHIPAJ
WHERE Experienta > p_experienta_noua;
RETURN v_numar_membri_experienta_mare;
END;
/

DECLARE
v_id_membru ECHIPAJ.Id_membru%TYPE := 1;
v_experienta_noua ECHIPAJ.Experienta%TYPE := 7;
v_numar_membri_experienta_mare NUMBER(10);
BEGIN
v_numar_membri_experienta_mare := actualizare_experienta(v_id_membru, v_experienta_noua);
DBMS_OUTPUT.PUT_LINE('Numarul total de membri ai echipajului cu experienta mai mare decat ' || v_experienta_noua || ': ' || v_numar_membri_experienta_mare);
END;
/



CREATE OR REPLACE PROCEDURE inserare_pasager(
    p_id_pasager IN PASAGERI.Id_pasager%TYPE,
    p_nume_pasager IN PASAGERI.Nume_pasager%TYPE,
    p_prenume_pasager IN PASAGERI.Prenume_pasager%TYPE,
    p_varsta_pasager IN PASAGERI.Varsta_pasager%TYPE
) IS
BEGIN
INSERT INTO PASAGERI(Id_pasager, Nume_pasager, Prenume_pasager, Varsta_pasager)
VALUES (p_id_pasager, p_nume_pasager, p_prenume_pasager, p_varsta_pasager);
DBMS_OUTPUT.PUT_LINE('Pasagerul cu ID-ul ' || p_id_pasager || ' a fost inserat cu succes.');
END;
/

BEGIN
inserare_pasager(15, 'Izvoranu', 'Florian', 25);
END;
/



CREATE OR REPLACE PROCEDURE actualizare_durata_cursa(
p_id_cursa IN CURSE.Id_cursa%TYPE,
p_durata_cursa IN CURSE.Durata_cursa%TYPE
) IS
BEGIN
UPDATE CURSE
SET Durata_cursa = p_durata_cursa
WHERE Id_cursa = p_id_cursa;
DBMS_OUTPUT.PUT_LINE('Durata cursei cu ID-ul ' || p_id_cursa || ' a fost actualizat? cu succes.');
END;
/

BEGIN
actualizare_durata_cursa(1, 120);
END;
/



CREATE OR REPLACE PROCEDURE stergere_membru_echipaj(
p_id_membru IN ECHIPAJ.Id_membru%TYPE
) IS
BEGIN
DELETE FROM ECHIPAJ
WHERE Id_membru = p_id_membru;
DBMS_OUTPUT.PUT_LINE('Membrul echipajului cu ID-ul ' || p_id_membru || ' a fost sters cu succes.');
END;
/

BEGIN
stergere_membru_echipaj(20);
END;
/








CREATE OR REPLACE PACKAGE avioane_pkg IS
FUNCTION calcul_durata_zbor(p_id_zbor IN ZBORURI.Id_zbor%TYPE) RETURN NUMBER;
PROCEDURE inregistrare_membru_echipaj(
p_id_echipaj IN ECHIPAJ.Id_echipaj%Type,
p_id_zbor IN ECHIPAJ.Id_zbor%TYPE,
p_id_membru IN ECHIPAJ.Id_membru%TYPE,
p_nume_membru IN ECHIPAJ.Nume_membru%TYPE,
p_functie IN ECHIPAJ.Functie%TYPE,
p_experienta IN ECHIPAJ.Experienta%TYPE,
p_id_superior IN ECHIPAJ.Id_superior%TYPE
);
FUNCTION numar_bilete_vandute(p_id_zbor IN ZBORURI.Id_zbor%TYPE) RETURN NUMBER;
END avioane_pkg;
/

CREATE OR REPLACE PACKAGE BODY avioane_pkg IS
FUNCTION calcul_durata_zbor(p_id_zbor IN ZBORURI.Id_zbor%TYPE) RETURN NUMBER IS
v_durata NUMBER;
BEGIN
SELECT Durata_cursa INTO v_durata
FROM CURSE
WHERE Id_cursa = (SELECT Id_cursa FROM ZBORURI WHERE Id_zbor = p_id_zbor);
RETURN v_durata;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN NULL;
END calcul_durata_zbor;

PROCEDURE inregistrare_membru_echipaj(
p_id_echipaj IN ECHIPAJ.Id_echipaj%Type,
p_id_zbor IN ECHIPAJ.Id_zbor%TYPE,
p_id_membru IN ECHIPAJ.Id_membru%TYPE,
p_nume_membru IN ECHIPAJ.Nume_membru%TYPE,
p_functie IN ECHIPAJ.Functie%TYPE,
p_experienta IN ECHIPAJ.Experienta%TYPE,
p_id_superior IN ECHIPAJ.Id_superior%TYPE
) IS
BEGIN
INSERT INTO ECHIPAJ(Id_echipaj, Id_zbor, Id_membru, Nume_membru, Functie, Experienta, Id_superior)
VALUES (p_id_echipaj, p_id_zbor, p_id_membru, p_nume_membru, p_functie, p_experienta, p_id_superior);
END inregistrare_membru_echipaj;

FUNCTION numar_bilete_vandute(p_id_zbor IN ZBORURI.Id_zbor%TYPE) RETURN NUMBER IS
v_numar_bilete NUMBER;
BEGIN
SELECT COUNT(*) INTO v_numar_bilete
FROM BILETE
WHERE Id_zbor = p_id_zbor;
RETURN v_numar_bilete;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN NULL;
END numar_bilete_vandute;
END avioane_pkg;
/

BEGIN
    DECLARE
    v_id_zbor ZBORURI.Id_zbor%TYPE := 7;
    v_durata_zbor NUMBER;
    BEGIN
    v_durata_zbor := avioane_pkg.calcul_durata_zbor(v_id_zbor);
    DBMS_OUTPUT.PUT_LINE('Durata zborului cu ID ' || v_id_zbor || ' este: ' || v_durata_zbor || ' minute.');
    END;

    BEGIN
    avioane_pkg.inregistrare_membru_echipaj(6, 6, 21, 'Mircea', 'pilot', 15, null);
    DBMS_OUTPUT.PUT_LINE('Membrul echipajului a fost înregistrat cu succes.');
    END;

    DECLARE
    v_id_zbor ZBORURI.Id_zbor%TYPE := 3;
    v_numar_bilete NUMBER;
    BEGIN
    v_numar_bilete := avioane_pkg.numar_bilete_vandute(v_id_zbor);
    DBMS_OUTPUT.PUT_LINE('Num?rul de bilete vândute pentru zborul cu ID ' || v_id_zbor || ' este: ' || v_numar_bilete);
    END;
END;
/



CREATE OR REPLACE TRIGGER trg_before_insert_pasageri
BEFORE INSERT ON PASAGERI
FOR EACH ROW
DECLARE
    v_full_name VARCHAR2(200);
BEGIN
    v_full_name := :NEW.Nume_pasager || ' ' || :NEW.Prenume_pasager;
    :NEW.Nume_pasager := UPPER(:NEW.Nume_pasager); -- Convertim numele în majuscule
    :NEW.Prenume_pasager := UPPER(:NEW.Prenume_pasager); -- Convertim prenumele în majuscule
    DBMS_OUTPUT.PUT_LINE('Se insereaza pasagerul: ' || v_full_name);
END;
/



CREATE OR REPLACE TRIGGER trg_delete_cursa
AFTER DELETE ON CURSE
FOR EACH ROW
DECLARE
    v_message VARCHAR2(100);
BEGIN
    v_message := 'Cursa cu ID-ul ' || :OLD.Id_cursa || ' a fost stearsa.';
    DBMS_OUTPUT.PUT_LINE(v_message);
END;
/



CREATE OR REPLACE TRIGGER trg_check_zboruri_time
BEFORE INSERT OR UPDATE ON ZBORURI
FOR EACH ROW
DECLARE
    v_ora_curenta NUMBER := TO_NUMBER(TO_CHAR(SYSDATE, 'HH24'));
    v_minut_curent NUMBER := TO_NUMBER(TO_CHAR(SYSDATE, 'MI'));
BEGIN
    IF v_ora_curenta >= 22 OR (v_ora_curenta = 21 AND v_minut_curent > 30) THEN
        IF INSERTING THEN
            RAISE_APPLICATION_ERROR(-20001, 'Nu se pot introduce zboruri dup? ora 21:30.');
        ELSIF UPDATING THEN
            RAISE_APPLICATION_ERROR(-20002, 'Nu se pot modifica zborurile dup? ora 21:30.');
        END IF;
    END IF;
END;
/



CREATE OR REPLACE TRIGGER trg_delete_pasageri
BEFORE DELETE ON PASAGERI
FOR EACH ROW
DECLARE
    v_current_hour NUMBER := TO_NUMBER(TO_CHAR(SYSDATE, 'HH24'));
BEGIN
    IF v_current_hour >= 23 OR v_current_hour < 8 THEN
    IF DELETING THEN
        DBMS_OUTPUT.PUT_LINE('Nu se pot ?terge pasagerii în afara intervalului orar 08:00 - 23:00.');
    END IF;
    END IF;
END;
/





