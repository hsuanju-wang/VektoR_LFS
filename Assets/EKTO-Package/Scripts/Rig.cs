using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using EKTO_Unity_Plugin;

public class Rig : EktoEventListener
{
    public GameObject leftBoot;
    public GameObject rightBoot;
    public GameObject hip;

    public Material glowMaterial;
    public Material normalMaterial;

    // Start is called before the first frame update
    void Start()
    {
        leftBoot.SetActive(true);
        rightBoot.SetActive(true);
        hip.SetActive(true);
        EktoVRManager.S.ekto.AddEventListener(this);
    }

    // Update is called once per frame
    void Update()
    {
        leftBoot.transform.localPosition = EktoVRManager.S.ekto.GetBootPosition(Handedness.LEFT);
        rightBoot.transform.localPosition = EktoVRManager.S.ekto.GetBootPosition(Handedness.RIGHT);
        hip.transform.localPosition = EktoVRManager.S.ekto.GetUserHipPosition();

        leftBoot.transform.localRotation = EktoVRManager.S.ekto.GetBootRotation(Handedness.LEFT);
        rightBoot.transform.localRotation = EktoVRManager.S.ekto.GetBootRotation(Handedness.RIGHT);

        if (EktoVRManager.S.ekto.IsBootInStartingZone(Handedness.LEFT) || EktoVRManager.S.ekto.IsSystemActivated())
        {
            //leftBoot.GetComponentInChildren<Renderer>().material.color = Color.green;
            leftBoot.GetComponentInChildren<Renderer>().material = glowMaterial;
        }
        else
        {
            //leftBoot.GetComponentInChildren<Renderer>().material.color = Color.white;
            leftBoot.GetComponentInChildren<Renderer>().material = normalMaterial;
        }

        if (EktoVRManager.S.ekto.IsBootInStartingZone(Handedness.RIGHT) || EktoVRManager.S.ekto.IsSystemActivated())
        {
            //rightBoot.GetComponentInChildren<Renderer>().material.color = Color.green;
            rightBoot.GetComponentInChildren<Renderer>().material = glowMaterial;
        }
        else
        {
            //rightBoot.GetComponentInChildren<Renderer>().material.color = Color.white;
            rightBoot.GetComponentInChildren<Renderer>().material = normalMaterial;
        }
        if (EktoVRManager.S.ekto.IsHipInStartingZone())
        {
            hip.GetComponent<Renderer>().material.color = Color.green;
        }
        else
        {
            hip.GetComponent<Renderer>().material.color = Color.white;
        }
        rightBoot.SetActive(EktoVRManager.S.ekto.IsBootTracked(Handedness.RIGHT));
        leftBoot.SetActive(EktoVRManager.S.ekto.IsBootTracked(Handedness.LEFT));
    }
    public override void OnServerConnected()
    {
        if (!this.gameObject.activeSelf) this.gameObject.SetActive(true);
        leftBoot.SetActive(true);
        rightBoot.SetActive(true);
        hip.SetActive(true);
    }
    public override void OnServerDisconnected()
    {
        if (this.gameObject.activeSelf) this.gameObject.SetActive(false);
        leftBoot.SetActive(false);
        rightBoot.SetActive(false);
        hip.SetActive(false);
    }
}
