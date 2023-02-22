using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ControlButton : MonoBehaviour
{
    public GameObject lightDim;
    public GameObject lightActive;

    //public GameObject dialoguePiece;
    private DialogueManager dialogueManager;

    void Start()
    {
        dialogueManager = FindObjectOfType<DialogueManager>();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("hand"))
        {
            GetComponent<Collider>().enabled = false;
            LightUpShip();
            dialogueManager.NextDialoguePiece();
        }
    }

    private void LightUpShip()
    {
        lightDim.SetActive(false);
        lightActive.SetActive(true);
    }

    
}
