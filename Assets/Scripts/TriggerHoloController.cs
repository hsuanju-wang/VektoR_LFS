using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriggerHoloController : MonoBehaviour
{
    public float riseHeight;
    public float speed;
    public GameObject holo_controller;

    private float height;

    // Start is called before the first frame update
    void Start()
    {
        height = 0;
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
            StartCoroutine(controllerRise());
            
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
