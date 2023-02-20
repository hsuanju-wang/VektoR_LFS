using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class squareAppear : MonoBehaviour
{
    public GameObject square;

    public bool isLast;
    public bool isFirst;

    public GameObject DialoguePanel;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("foot"))
        {
            if (isFirst)
            {
                DialoguePanel.SetActive(false);
                ///GetComponent<Dialogue>().TriggerDialogue();
            }

            if (!isLast)
            {
                square.SetActive(true);
            }
            else
            {
                PlayerPrefs.SetString("StepSquares", "Done");
            }
            GameObject.Destroy(this.gameObject);
        }
    }
}
