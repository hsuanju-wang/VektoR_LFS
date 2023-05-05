using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using EKTO_Unity_Plugin;
using UnityEngine.SceneManagement;

public class NewStatusHud : MonoBehaviour
{
    private bool startFadeout;
    private bool prevSystemActiveState;
    public GameObject bootBreakUI;
    public GameObject bootActivateUI;
    public GameObject glowingButton;
    void Awake()
    {
        GameObject[] objs = GameObject.FindGameObjectsWithTag("NewStatusHud");

        if (objs.Length > 1)
        {
            Destroy(this.gameObject);
        }

        DontDestroyOnLoad(this.gameObject);
    }

    // Start is called before the first frame update
    void Start()
    {
        startFadeout = false;
        prevSystemActiveState = EktoVRManager.S.ekto.IsSystemActivated();
    }

    // Update is called once per frame
    void Update()
    {
        if (glowingButton == null)
        {
            glowingButton = GameObject.FindGameObjectWithTag("GlowingButton");
        }

        if (EktoVRManager.S.ekto.IsSystemActivated())
        {
            if (prevSystemActiveState == false)
            {
                prevSystemActiveState = true;
                Debug.Log("System On!");
                bootBreakUI.SetActive(false);
                bootActivateUI.SetActive(true);
                glowingButton.GetComponent<MeshRenderer>().enabled = false;
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
                glowingButton.GetComponent<MeshRenderer>().enabled = true;
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
        glowingButton.GetComponent<MeshRenderer>().enabled = false;
    }
}

