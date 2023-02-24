using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriggerHoloController : MonoBehaviour
{
    public float riseHeight;
    public float speed;
    public GameObject holo_controller;


    public GameObject task;
    private float height;


    // Start is called before the first frame update
    void Start()
    {
        height = 0;
        //dialogueManager = FindObjectOfType<DialogueManager>();
        //StartCoroutine(controllerRise());
    }

    // Update is called once per frame
    void Update()
    {

    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("foot"))
        {
            GetComponent<Collider>().enabled = false;
            StartCoroutine(controllerRise());
            //dialogueManager.NextDialoguePiece();
            task.GetComponent<Task>().EndTask();
        }
    }

    private IEnumerator controllerRise()
    {
        while (height <= riseHeight)
        {
            height += speed * Time.deltaTime;
            holo_controller.transform.position += new Vector3(0f, speed * Time.deltaTime, 0f);
            yield return null;
        }

        //Enable boxcollider
        holo_controller.GetComponent<Collider>().enabled = true;
    }
}
