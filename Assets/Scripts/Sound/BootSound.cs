using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BootSound : MonoBehaviour
{
    public AudioSource audioSource;

    public bool bootSoundIsOff;
    public bool bootIsMoved;

    // Start is called before the first frame update
    void Start()
    {
        audioSource = GetComponent<AudioSource>();
    }

    // Update is called once per frame
    void Update()
    {


    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("floor"))
        {
            //Debug.Log("Trigger floor");
            if (!bootSoundIsOff)
            {
                PlayBootSound();
            }
            
        }
    }

    private void PlayBootSound()
    {
        //Debug.Log("Play Left Boot Sound");
        audioSource.Play();
    }

}
