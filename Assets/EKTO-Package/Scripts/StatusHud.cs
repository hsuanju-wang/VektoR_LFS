using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using EKTO_Unity_Plugin;

public class StatusHud : MonoBehaviour
{ 
    public TextMeshProUGUI statusText;
    private bool startFadeout;
    private bool prevSystemActiveState;


    // Start is called before the first frame update
    void Start()
    {
        statusText.text = "Caution: Boots are Disabled and Braked";
        statusText.enabled = true;
        startFadeout = false;
        prevSystemActiveState = false;
    }

    // Update is called once per frame
    void Update()
    {
        if(EktoVRManager.S.ekto.IsSystemActivated())
        {
            if (prevSystemActiveState == false)
            {
                prevSystemActiveState = true;
                Debug.Log("System On!");
                statusText.text = "Boots are Enabled and Active!";
                startFadeout = true;
            }
        }

        if (!EktoVRManager.S.ekto.IsSystemActivated())
        {
            if (prevSystemActiveState == true)
            {
                prevSystemActiveState = false;
                Debug.Log("System Off!");
                statusText.text = "Caution: Boots are Disabled and Braked";
                statusText.enabled = true;
            }
        }

        if (startFadeout)
        {
            startFadeout = false;
            StartCoroutine(Fadeout());
        }

    }

    public IEnumerator Fadeout()
    {
        Debug.Log("called");
        yield return new WaitForSeconds(3);
        statusText.enabled = false;
    }
}

    /*public override void OnSystemActivated()
    {
        Debug.Log("System On!");
        statusText.text = "Boots are Enabled and Active!";
        startFadeout = true;
    }

    public override void OnSystemDeactivated(string deactivationReason)
    {
        Debug.Log("System Off!");
        statusText.text = "Caution: Boots are Disabled and Braked";
        statusText.enabled = true;
    }*/