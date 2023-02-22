using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ControlButton : MonoBehaviour
{
    public GameObject lightDim;
    public GameObject lightActive;

    public GameObject teleportHint;

    //public GameObject dialoguePiece;
    private DialogueManager dialogueManager;
    // Start is called before the first frame update
    void Start()
    {
        dialogueManager = FindObjectOfType<DialogueManager>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("hand"))
        {
            GetComponent<Collider>().enabled = false;
            lightDim.SetActive(false);
            lightActive.SetActive(true);
            teleportHint.SetActive(true);
            dialogueManager.NextDialoguePiece();
            //dialogueManager.StartDialogue(dialoguePiece, true);
        }
    }

    
}
