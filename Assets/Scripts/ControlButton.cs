using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ControlButton : MonoBehaviour
{
    public GameObject lightDim;
    public GameObject lightActive;

    //public GameObject dialoguePiece;
    private DialogueManager dialogueManager;
    private SoundManager soundManager;

    void Start()
    {
        dialogueManager = FindObjectOfType<DialogueManager>();
        soundManager = FindObjectOfType<SoundManager>();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("hand"))
        {
            GetComponent<Collider>().enabled = false;
            LightUpShip();
            StartCoroutine(PlaySounds());
        }
    }

    private IEnumerator PlaySounds()
    {
        float soundLength = soundManager.PlayControllerScan();
        yield return new WaitForSeconds(soundLength);

        soundLength = soundManager.PlayPowerOn();
        yield return new WaitForSeconds(soundLength);

        dialogueManager.NextDialoguePiece();
    }

    private void LightUpShip()
    {
        lightDim.SetActive(false);
        lightActive.SetActive(true);
    }

    
}
