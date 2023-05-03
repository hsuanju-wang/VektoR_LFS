using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PopTrigger : MonoBehaviour
{
    //public PopSample popSample;
    public GameObject particles;
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("foot"))
        {
            //popSample.popOut();
            particles.SetActive(true);
            this.GetComponent<Collider>().enabled = false;
        }
    }
}
