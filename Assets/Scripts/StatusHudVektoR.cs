using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using EKTO_Unity_Plugin;

public class StatusHudVektoR : MonoBehaviour
{
    private bool startFadeout;
    private bool prevSystemActiveState;
    public GameObject bootBreakUI;
    public GameObject bootActivateUI;

    public GameObject glowingButton;

    // Start is called before the first frame update
    void Start()
    {
        //bootBreakUI.SetActive(true);
        startFadeout = false;
        prevSystemActiveState = false;
    }

    // Update is called once per frame
    void Update()
    {
        if (EktoVRManager.S.ekto.IsSystemActivated())
        {
            if (prevSystemActiveState == false)
            {
                prevSystemActiveState = true;
                Debug.Log("System On!");
                bootBreakUI.SetActive(false);
                bootActivateUI.SetActive(true);
                glowingButton.SetActive(false);
                startFadeout = true;
            }
        }

        if (!EktoVRManager.S.ekto.IsSystemActivated())
        {
            if (prevSystemActiveState == true)
            {
                prevSystemActiveState = false;
                Debug.Log("System Off!");
                bootActivateUI.SetActive(false);
                bootBreakUI.SetActive(true);
                glowingButton.SetActive(true);
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
        bootActivateUI.SetActive(false);
        bootBreakUI.SetActive(false);
        glowingButton.SetActive(false);
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
