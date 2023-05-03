using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ControlButton : MonoBehaviour
{
    public GameObject lightDim;
    public GameObject lightActive;

    public Material[] materials;
    public GameObject[] lights;

    public float controllerStayTime;

    //public GameObject dialoguePiece;
    private InSpaceshipDM dialogueManager;
    private SoundManager soundManager;

    void Start()
    {
        dialogueManager = FindObjectOfType<InSpaceshipDM>();
        soundManager = FindObjectOfType<SoundManager>();
        LightOffConsole();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("hand"))
        {
            GetComponent<Collider>().enabled = false;
            StartCoroutine(CloseController());
            dialogueManager.CloseScanPopup();
            StartCoroutine(PlaySounds());
            StartCoroutine(LightUpConsole());
        }
    }

    private IEnumerator PlaySounds()
    {
        //For test
        //yield return new WaitForSeconds(4f);
        float soundLength = soundManager.PlayPowerOn();
        yield return new WaitForSeconds(soundLength);
        dialogueManager.StartConsoleDialogues();
    }

    private IEnumerator LightUpConsole()
    {
        //For test
        //yield return new WaitForSeconds(4f);
        foreach (Material material in materials)
        {
            //material.shader.GetPropertyCount();
            material.SetFloat("EmissionStrength", 1);
            yield return new WaitForSeconds(0.7f);
        }
        lightDim.SetActive(false);
        lightActive.SetActive(true);
    }

    private void LightOffConsole()
    {
        foreach (Material material in materials)
        {
            //material.shader.GetPropertyCount();
            material.SetFloat("EmissionStrength", -1);
        }
    }

    private IEnumerator CloseController()
    {
        yield return new WaitForSeconds(controllerStayTime);
        GetComponent<MeshRenderer>().enabled = false;
    }
}
